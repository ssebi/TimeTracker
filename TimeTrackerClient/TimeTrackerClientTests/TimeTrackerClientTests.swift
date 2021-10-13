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
        var receivedError: Error? = nil
        var receivedResult: AuthDataResult? = nil
        let exp = expectation(description: "Witing to complete")
        
        /// When
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            receivedError = error
            receivedResult = result
            exp.fulfill()
            
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("success")
            }
            
        }
        
        wait(for: [exp], timeout: 5)
        
        /// Then
        XCTAssertNil(receivedResult)
        XCTAssertNotNil(receivedError)
    }
    
}
