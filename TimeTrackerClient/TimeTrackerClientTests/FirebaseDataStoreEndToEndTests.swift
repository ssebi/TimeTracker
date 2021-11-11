//
//  FirebaseDataStoreIntegrationTests.swift
//  FirebaseDataStoreIntegrationTests
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import XCTest
import Firebase
@testable import TimeTrackerClient

class FirebaseDataStoreEndToEndTests: XCTestCase {
    
    func test_addTimeSlot_isSusccesfullOnAdd() {
        let sut = makeSUT(withUserSignedIn: true)
        let slot = TimeSlotDetail(start: Date() + 1, end: Date() + 1, description: "First dscription for log time")
        let exp = expectation(description: "Wait for firebase")
        var receivedError: Error?
        let data: [String: Any] = [
            "start": slot.start,
            "end": slot.end,
            "description": slot.description,
        ]

        sut.addTimeSlot(with: data, to: path) { error in
            receivedError = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        XCTAssertNil(receivedError)
    }
    
    func _test_addTimeSlot_isNotSusccesfullWithoutUser() {
        let sut = makeSUT(withUserSignedIn: false)
        let slot = TimeSlotDetail(start: Date(), end: Date() + 1, description: "First dscription for log time")
        let exp = expectation(description: "Wait for firebase")
        let data: [String: Any] = [
            "start": slot.start,
            "end": slot.end,
            "description": slot.description,
        ]

        var receivedError: Error?
        sut.addTimeSlot(with: data, to: path) { error in
            receivedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertNotNil(receivedError)
    }

    // MARK: - Helper
    let email: String = "mihai24vic@gmail.com"
    let wrongPassword: String = "123452435324"
    let password: String = "Patratel1"
    let path: String = "timeSlots"

    private func makeSUT(withUserSignedIn signedIn: Bool, file: StaticString = #filePath, line: UInt = #line) -> DataStore {
        let session = SessionStore(authProvider: FirebaseAuthProvider())

        if signedIn {
            signIn(session)
        } else {
            signOut(session)
        }

        let sut = DataStore()
        
        addTeardownBlock { [weak session, weak sut] in
            XCTAssertNil(session, file: file, line: line)
            XCTAssertNil(sut, file: file, line: line)
        }
        return sut
    }

    private func signIn(_ session: SessionStore) {
        let exp = expectation(description: "Waiting to complete")
        session.signIn(email: email, password: password) { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }

    private func signOut(_ sut: SessionStore) {
        sut.signOut()
    }
    
}
