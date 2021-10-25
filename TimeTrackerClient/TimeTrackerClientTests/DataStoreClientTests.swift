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
        let sut = makeSUT()
        let slot = TimeSlot(id: UUID(), start: Date.now, end: Date.now + 1, description: "First dscription for log time")
        let dataStore = DataStore()
        let exp = expectation(description: "Wait for firebase")
        var receivedError: Error?
        let data: [String: Any] = [
            "start": slot.start,
            "end": slot.end,
            "description": slot.description,
        ]

        singIn(sut: sut)
        dataStore.addTimeSlot(with: data, from: path) { error in
            receivedError = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        XCTAssertNil(receivedError)
    }
    
    func test_addTimeSlot_isNotSusccesfullWithoutUser() {
        let sut = makeSUT()
        let dataStore = DataStore()
        let slot = TimeSlot(id: UUID(), start: Date.now, end: Date.now + 1, description: "First dscription for log time")
        let exp = expectation(description: "Wait for firebase")
        let data: [String: Any] = [
            "start": slot.start,
            "end": slot.end,
            "description": slot.description,
        ]
        var receivedError: Error?
        
        signOut(sut: sut)

        dataStore.addTimeSlot(with: data, from: path) { error in
            receivedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertNotNil(receivedError)
    }
    
    func test_getTimeSlot_isSusccesfullOnRead() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for fir")
        singIn(sut: sut)
        let dataStore = DataStore()
        var receivedError: Error?
        
        dataStore.getTimeSlot(from: path) { error in
            receivedError = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        XCTAssertNil(receivedError)
        
        //add assert fo  valid timeslot
    }
    
    func test_getTimeSlot_isNotSusccesfullWithNoSession() {
        let sut = makeSUT()
        let dataStore = DataStore()
        let exp = expectation(description: "Wait for firebase")
        var receivedError: Error?
        
        signOut(sut: sut)
        XCTAssertNil(sut.session)
        
        dataStore.getTimeSlot(from: path) { error in
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
    
    private func singIn(sut: SessionStore) {
        let exp = expectation(description: "Waiting to complete")
        sut.singIn(email: email, password: password) { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
    
    private func signOut(sut: SessionStore) {
        var subscriptions: Set<AnyCancellable> = []
        let exp = expectation(description: "Wait for session to be nil")
        
        XCTAssertTrue(sut.singOut())
        
        sut.didChange.sink(receiveValue: { store in
            exp.fulfill()
        }).store(in: &subscriptions)
        
        wait(for: [exp], timeout: 5)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> SessionStore {
        let sut = SessionStore()
        
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, file: file, line: line)
        }
        return sut
    }
    
}
