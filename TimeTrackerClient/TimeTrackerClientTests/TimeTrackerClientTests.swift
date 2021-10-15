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
    
    func testFirebaseFailsWithWrongCredentials() throws {
        /// Given
        let email: String = "mihai24vic"
        let password: String = "123Password"
        let exp = expectation(description: "Waiting to complete")
        var sesionStoreResult: Result<User, Error>? = nil
        
        /// When
        let session = SessionStore()
        session.singIn(email: email, password: password) { result in
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
    
    func testFirebaseAuthSuscces() throws {
        /// Given
        let email: String = "mihai24vic@gmail.com"
        let password: String = "Patratel1"
        let exp = expectation(description: "Waiting to complete")
        var sesionStoreResult: Result<User, Error>? = nil
        
        /// When
        let session = SessionStore()
        session.singIn(email: email, password: password) { result in
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

}
