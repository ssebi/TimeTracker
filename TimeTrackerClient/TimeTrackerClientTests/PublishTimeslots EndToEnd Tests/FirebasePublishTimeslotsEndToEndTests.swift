//
//  FirebaseDataStoreIntegrationTests.swift
//  FirebaseDataStoreIntegrationTests
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import XCTest
import Firebase
@testable import TimeTrackerClient

class FirebasePublishTimeslotsEndToEndTests: XCTestCase {

    func test_addTimeSlot_isSusccesfullOnAdd() {
        let sut = makeSUT(withUserSignedIn: true)
        let details = TimeSlotDetails(start: Date(), end: Date() + 1, description: "EndToEndTesting")
		let timeslot = TimeSlot(id: UUID().uuidString, userId: UUID().uuidString, clientName: "someClient", projectName: "SomeProject", date: Date(), details: details, total: 1)
		var receivedError: Error?

		let exp = expectation(description: "Wait for firebase")
        sut.addTimeSlot(timeslot) { error in
            receivedError = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        XCTAssertNil(receivedError)
    }
	
    // MARK: - Helper

    let email: String = "mihai24vic@gmail.com"
    let wrongPassword: String = "123452435324"
    let password: String = "Patratel1"
    let path: String = "timeSlots"

	private func makeSUT(withUserSignedIn signedIn: Bool, file: StaticString = #filePath, line: UInt = #line) -> TimeSlotsPublisher {
        let session = SessionStore(authProvider: FirebaseAuthProvider())

        if signedIn {
            signIn(session)
        } else {
            signOut(session)
        }

		let sut = RemoteTimeSlotsPublisher(store: FirebaseTimeslotsStore())
        
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
