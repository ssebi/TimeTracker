//
//  TimeTrackerClientTests.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 13.10.2021.
//

import XCTest
import Firebase
@testable import TimeTrackerClient

class TimeTrackerClientTests: XCTestCase {

    /// sut = system under test

    func test_signIn_failsWithInvalidCredentials() throws {
        /// Given
        let sut = SessionStore()
        let email: String = "mihai24vic"
        let password: String = "123Password"
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
        if case let .failure(authErr) = sesionStoreResult {
            XCTAssertNil(authErr as? SessionStore.NoUser)
        } else {
            XCTFail("Expected to receive failure, got success instead")
        }
    }
    
    func test_signIn_isSuccessfulOnSingleFunctionCall() throws {
        /// Given
        let sut = SessionStore()
        let email: String = "mihai24vic@gmail.com"
        let password: String = "Patratel1"
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
        let sut = SessionStore()
        let email: String = "mihai24vic@gmail.com"
        let password: String = "Patratel1"
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

    func test_signOut_setsSessionAsNil() {
        let sut = SessionStore()
        sut.session = User(uid: nil, email: nil, username: nil)

        XCTAssertNoThrow(sut.singOut())

        XCTAssertNil(sut.session)
    }

}
