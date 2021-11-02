//
//  x.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import XCTest
import Firebase
import Combine
@testable import TimeTrackerClient

class DataStoreClientTests: XCTestCase {
    
    func test_addTimeSlot_isSusccesfullOnAdd() {
        let sut = makeSUT(withUserSignedIn: true)
        let slot = TimeSlotDetail(start: Date.now + 1, end: Date.now + 1, description: "First dscription for log time")
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
        wait(for: [exp], timeout: 1)
        
        XCTAssertNil(receivedError)
    }
    
    func test_addTimeSlot_isNotSusccesfullWithoutUser() {
        let sut = makeSUT(withUserSignedIn: false)
        let slot = TimeSlotDetail(start: Date.now, end: Date.now + 1, description: "First dscription for log time")
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
    
    func test_getTimeSlot_isSusccesfullOnRead() {
        let sut = makeSUT(withUserSignedIn: true)
        let exp = expectation(description: "Wait for fir")
        var receivedResult: Result<QuerySnapshot, Error>?
        
        sut.listenForTimeSlot(from: path) { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        if case let .success(qerySnapshot) = receivedResult {
            XCTAssertNotNil(qerySnapshot)
        } else {
            XCTFail()
        }
    }
    
    func test_getTimeSlot_isNotSusccesfullWithNoSession() {
        let sut = makeSUT(withUserSignedIn: false)
        let exp = expectation(description: "Wait for firebase")
        var receivedResult: Result<QuerySnapshot, Error>?

        sut.listenForTimeSlot(from: path) { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        if case let .failure(error) = receivedResult {
            XCTAssertNotNil(error)
        } else {
            XCTFail()
        }
    }
    
    // MARK: - Helper
    let email: String = "mihai24vic@gmail.com"
    let wrongPassword: String = "123452435324"
    let password: String = "Patratel1"
    let path: String = "timeSlots"

    private func makeSUT(withUserSignedIn signedIn: Bool, file: StaticString = #filePath, line: UInt = #line) -> DataStore {
        let session = SessionStore()

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
        session.singIn(email: email, password: password) { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }

    private func signOut(_ sut: SessionStore) {
        sut.singOut()
    }
    
}
