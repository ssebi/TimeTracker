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
        _ = makeSUT(withUserSignedIn: true)
        let slot = TimeSlot(id: UUID(), start: Date.now, end: Date.now + 1, description: "First dscription for log time")
        let dataStore = DataStore()
        let exp = expectation(description: "Wait for firebase")
        var receivedError: Error?
        let data: [String: Any] = [
            "start": slot.start,
            "end": slot.end,
            "description": slot.description,
        ]

        dataStore.addTimeSlot(with: data, from: path) { error in
            receivedError = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        XCTAssertNil(receivedError)
    }
    
    func test_addTimeSlot_isNotSusccesfullWithoutUser() {
        let _ = makeSUT(withUserSignedIn: false)
        let dataStore = DataStore()
        let slot = TimeSlot(id: UUID(), start: Date.now, end: Date.now + 1, description: "First dscription for log time")
        let exp = expectation(description: "Wait for firebase")
        let data: [String: Any] = [
            "start": slot.start,
            "end": slot.end,
            "description": slot.description,
        ]

        var receivedError: Error?
        dataStore.addTimeSlot(with: data, from: path) { error in
            receivedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertNotNil(receivedError)
    }
    
    func test_getTimeSlot_isSusccesfullOnRead() {
        let _ = makeSUT(withUserSignedIn: true)
        let exp = expectation(description: "Wait for fir")
        let dataStore = DataStore()
        var receivedResult: Result<QuerySnapshot, Error>?
        
        dataStore.getTimeSlot(from: path) { result in
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
        let _ = makeSUT(withUserSignedIn: false)
        let dataStore = DataStore()
        let exp = expectation(description: "Wait for firebase")
        var receivedResult: Result<QuerySnapshot, Error>?

        dataStore.getTimeSlot(from: path) { result in
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

    private func makeSUT(withUserSignedIn signedIn: Bool, file: StaticString = #filePath, line: UInt = #line) -> SessionStore {
        let sut = SessionStore()

        if signedIn {
            signIn(sut: sut)
        } else {
            signOut(sut: sut)
        }
        
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, file: file, line: line)
        }
        return sut
    }

    private func signIn(sut: SessionStore) {
        let exp = expectation(description: "Waiting to complete")
        sut.singIn(email: email, password: password) { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }

    private func signOut(sut: SessionStore) {
        sut.singOut()
    }
    
}
