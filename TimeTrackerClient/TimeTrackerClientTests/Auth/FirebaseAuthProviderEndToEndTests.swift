//
//  FirebaseAuthProviderIntegrationTests.swift
//  FirebaseAuthProviderIntegrationTests
//
//  Created by Bocanu Mihai on 13.10.2021.
//

import XCTest
import Firebase
import Combine
@testable import TimeTrackerClient

class FirebaseAuthProviderEndToEndTests: XCTestCase {

    /// sut = system under test
    
    func test_signIn_failsWithInvalidCredentials() throws {
        /// Given
        let sut = makeSUT()
		var sesionStoreResult: Result<TimeTrackerClient.User?, Error>? = nil

		/// When
        let exp = expectation(description: "Waiting to complete")
        sut.signIn(email: email, password: wrongPassword) { result in
            sesionStoreResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        /// Then
        XCTAssertNotNil(sesionStoreResult)
        if case let .failure(authErr) = sesionStoreResult {
            XCTAssertNil(authErr as? FirebaseAuthProvider.NoUser)
        } else {
            XCTFail("Expected to receive failure, got success instead")
        }
    }
    
    func test_signIn_isSuccessfulOnSingleFunctionCall() {
        /// Given
        let sut = makeSUT()
		var sesionStoreResult: Result<TimeTrackerClient.User?, Error>? = nil
        
        /// When
        let exp = expectation(description: "Waiting to complete")
        sut.signIn(email: email, password: correctPassword) { result in
            sesionStoreResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        /// Then
        XCTAssertNotNil(sesionStoreResult)
        if case let .success(user) = sesionStoreResult {
            XCTAssertEqual(user?.email, email)
        } else {
            XCTFail()
        }
    }

    func test_signIn_isSuccessfulOnMultipleFunctionCalls() throws {
        /// Given
        let sut = makeSUT()
		var sesionStoreResult: Result<TimeTrackerClient.User?, Error>? = nil
        
        /// When
        let exp = expectation(description: "Waiting to complete")
        exp.expectedFulfillmentCount = 3
        for _ in 0..<3 {
            sut.signIn(email: email, password: correctPassword) { result in
                sesionStoreResult = result
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 5)
        
        /// Then
        XCTAssertNotNil(sesionStoreResult)
        if case let .success(user) = sesionStoreResult {
            XCTAssertEqual(user?.email, email)
        } else {
            XCTFail()
        }
    }

	func test_checkAuthState_returnsNilWhenUserIsLoggedOut() throws {
		let sut = makeSUT()

		try sut.signOut()

		XCTAssertNil(sut.checkAuthState())
	}

	func test_checkAuthState_returnsUserWhenUserIsLoggedIn() throws {
		let sut = makeSUT()

		let exp = expectation(description: "Waiting to complete")
		sut.signIn(email: email, password: correctPassword, completion: { _ in
			exp.fulfill()
		})
		wait(for: [exp], timeout: 5)

		XCTAssertNotNil(sut.checkAuthState())
	}
    
    // MARK: - Helper
    let email: String = "mihai24vic@gmail.com"
    let wrongPassword: String = "123452435324" 
    let correctPassword: String = "Patratel1"
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> FirebaseAuthProvider {
        let sut = FirebaseAuthProvider()
        
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, file: file, line: line)
        }
        return sut
    }
}
