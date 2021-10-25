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
import SwiftUI

class DataStoreClientTests: XCTestCase {

    func test_addTimeSlot_isSusccesfullOnAdd() {
        let sut = makeSUT()
        let slot: TimeSlot = TimeSlot(id: UUID(), start: Date.now, end: Date.now + 1, description: "First dscription for log time")
        var err: Bool = false
        let dataStore = DataStore()
        
        singIn(sut: sut)
        
        let data: [String: Any] = [
            "start": slot.start,
            "end": slot.end,
            "description": slot.description,
        ]
        
        let path: String = "timeSlots"
        let exp = expectation(description: "Wait for firebase")
        
        dataStore.addTimeSlot(with: data, from: path) { error in
            err = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertFalse(err)
    }
    
    func test_addTimeSlot_isNotSusccesfullWithoutUser() {
        let sut = makeSUT()
        var err: Bool = false
        let dataStore = DataStore()
        let slot: TimeSlot = TimeSlot(id: UUID(), start: Date.now, end: Date.now + 1, description: "First dscription for log time")
        let data: [String: Any] = [
            "start": slot.start,
            "end": slot.end,
            "description": slot.description,
        ]
        signOut(sut: sut)
        XCTAssertNil(sut.session)
        
        let path: String = "timeSlots"
        let exp = expectation(description: "Wait for firebase")
        
        dataStore.addTimeSlot(with: data, from: path) { error in
            err = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertNotNil(err)
    }
    
    func test_getTimeSlot_isSusccesfullOnRead() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for fir")
        singIn(sut: sut)

        let path: String = "timeSlots"
        
        var err: Bool = false
        let dataStore = DataStore()
        
        dataStore.getTimeSlot(from: path) { error in
            err = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        XCTAssertFalse(err)
    }
    
    func test_getTimeSlot_isNotSusccesfullWithNoSession() {
        let sut = makeSUT()
        var err: Bool = false
        let dataStore = DataStore()
        let path: String = "timeSlots"
        let exp = expectation(description: "Wait for firebase")
        
        signOut(sut: sut)
        XCTAssertNil(sut.session)
        
        dataStore.getTimeSlot(from: path) { error in
            err = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(err)
    }
    
    
    
    // MARK: - Helper
    let email: String = "mihai24vic@gmail.com"
    let wrongPassword: String = "123452435324"
    let password: String = "Patratel1"
    
    private func singIn(sut: SessionStore){
        let exp = expectation(description: "Waiting to complete")
        sut.singIn(email: email, password: password) { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
    
    private func signOut(sut: SessionStore) {
        var subscriptions: Set<AnyCancellable> = []
        XCTAssertTrue(sut.singOut())
        
        let exp2 = expectation(description: "Wait for session to be nil")
        sut.didChange.sink(receiveValue: { store in
            exp2.fulfill()
        }).store(in: &subscriptions)
        
        wait(for: [exp2], timeout: 5)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> SessionStore {
        let sut = SessionStore()
        
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, file: file, line: line)
        }
        return sut
    }

}
