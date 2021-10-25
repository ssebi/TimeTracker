//
//  SessionStoreClientTests.swift
//  SessionStoreClientTests
//
//  Created by Bocanu Mihai on 13.10.2021.
//

import XCTest
import Firebase
import Combine
@testable import TimeTrackerClient

class SessionStoreClientTests: XCTestCase {
    
    /// sut = system under test
    
    func test_signIn_failsWithInvalidCredentials() throws {
        /// Given
        let sut = makeSUT()
        var sesionStoreResult: Result<User, Error>? = nil
        /// When
        let exp = expectation(description: "Waiting to complete")
        sut.singIn(email: email, password: wrongPassword) { result in
            sesionStoreResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        /// Then
        XCTAssertNotNil(sesionStoreResult)
        if case let .failure(authErr) = sesionStoreResult {
            XCTAssertNil(authErr as? SessionStore.NoUser)
        } else {
            XCTFail("Expected to receive failure, got success instead")
        }
    }
    
    func test_signIn_isSuccessfulOnSingleFunctionCall() {
        /// Given
        let sut = makeSUT()
        var sesionStoreResult: Result<User, Error>? = nil
        
        /// When
        let exp = expectation(description: "Waiting to complete")
        sut.singIn(email: email, password: password) { result in
            sesionStoreResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        /// Then
        XCTAssertNotNil(sesionStoreResult)
        if case let .success(user) = sesionStoreResult {
            XCTAssertEqual(user.email, email)
        } else {
            XCTFail()
        }
    }
    
    func test_signIn_isSuccessfulOnMultipleFunctionCalls() throws {
        /// Given
        let sut = makeSUT()
        var sesionStoreResult: Result<User, Error>? = nil
        
        /// When
        let exp = expectation(description: "Waiting to complete")
        exp.expectedFulfillmentCount = 3
        for _ in 0..<3 {
            sut.singIn(email: email, password: password) { result in
                sesionStoreResult = result
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 5)
        
        /// Then
        XCTAssertNotNil(sesionStoreResult)
        if case let .success(user) = sesionStoreResult {
            XCTAssertEqual(user.email, email)
        } else {
            XCTFail()
        }
    }
    
    func test_signIn_setsTheSession() throws {
        /// Given
        let sut = makeSUT()
        
        /// When
        let exp = expectation(description: "Waiting to complete")
        sut.singIn(email: email, password: password) { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        /// Then
        let session = try XCTUnwrap(sut.session)
        XCTAssertEqual(session.email, email)
    }
    
    func test_signOut_setsSessionAsNil() {
        let sut = makeSUT()
        var subscriptions: Set<AnyCancellable> = []
        
        let exp = expectation(description: "Waiting for session to have suer")
        sut.singIn(email: email, password: password, completion: { _ in
            exp.fulfill()
        })
        wait(for: [exp], timeout: 5)
        
        XCTAssertTrue(sut.singOut())
        
        let exp2 = expectation(description: "Wait for session to be nil")
        sut.didChange.sink(receiveValue: { store in
            exp2.fulfill()
        }).store(in: &subscriptions)
        
        wait(for: [exp2], timeout: 5)
        XCTAssertNil(sut.session)
    }
    
    func test_unbind_handleListener() {
        var sut: SessionStore? = makeSUT()
        
        /// When
        XCTAssertNotNil(sut?.handle)
        
        let exp = expectation(description: "Waiting to complete")
        sut?.singIn(email: email, password: password) { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        sut = nil
        
        /// Then
        XCTAssertNil(sut?.handle)
    }
    
    // MARK: - Helper
    let email: String = "mihai24vic@gmail.com"
    let wrongPassword: String = "123452435324"
    let password: String = "Patratel1"
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> SessionStore {
        let sut = SessionStore()
        
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, file: file, line: line)
        }
        return sut
    }
}
