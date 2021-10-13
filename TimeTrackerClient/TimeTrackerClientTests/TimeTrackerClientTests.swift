//
//  TimeTrackerClientTests.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 13.10.2021.
//

import XCTest
import Firebase


class TimeTrackerClientTests: XCTestCase {
    
    func testFirebaseFailsWithWrongCredentials() throws {
        
        /// Given
        let email: String = "mihai24vic@gmail.com"
        let password: String = "123Password123"
        let exp = expectation(description: "Witing to complete")
        
        /// When
        let session = SessionStore()
        session.singIn(email: email, password: password)
            exp.fulfill()
    
        
        
        wait(for: [exp], timeout: 5)
        
        /// Then
        XCTAssertNil(session.authResult)
        XCTAssertNotNil(session.authError)
    }
    
}
