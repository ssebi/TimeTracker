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
        let slot: TimeSlot = TimeSlot(id: UUID(), start: Date.now, end: Date.now + 1, description: "First dscription for log time")
        var err: Error?
        
        singIn(sut: sut)
        
        let data: [String: Any] = [
            "start": slot.start,
            "end": slot.end,
            "description": slot.description,
        ]
        
        let path: String = "timeSlots"
        var ref: DocumentReference? = nil
        let exp = expectation(description: "Wait for firebase")
        
        func addTimeSlot(data: [String: Any]){
            ref = Firestore.firestore().collection(path).addDocument(data: data) { error in
                err = error
                if err == nil {
                    print("Document added with ID: \(ref!.documentID)")
                } else {
                    print("There was an error addidng the document")
                }
                exp.fulfill()
            }
        }
        
        addTimeSlot(data: data)
        wait(for: [exp], timeout: 1)
        XCTAssertNil(err)
    }
    
    func test_addTimeSlot_isNotSusccesfullWithoutUser() {
        let sut = makeSUT()
    
        signOut(sut: sut)
        XCTAssertNil(sut.session)
        
        let slot: TimeSlot = TimeSlot(id: UUID(), start: Date.now, end: Date.now + 1, description: "First dscription for log time")
        var err: Error?
        let data: [String: Any] = [
            "start": slot.start,
            "end": slot.end,
            "description": slot.description,
        ]
        
        let path: String = "timeSlots"
        var ref: DocumentReference? = nil
        let exp = expectation(description: "Wait for firebase")
        
        func addTimeSlot(data: [String: Any]){
            ref = Firestore.firestore().collection(path).addDocument(data: data) { error in
                err = error
                if err == nil {
                    print("Document added with ID: \(ref!.documentID)")
                } else {
                    print("There was an error addidng the document")
                }
                exp.fulfill()
            }
        }
        
        addTimeSlot(data: data)
        wait(for: [exp], timeout: 1)
        
        XCTAssertNotNil(err)
    }
    
    func test_getTimeSlot_isSusccesfullOnRead() {
        let sut = makeSUT()
        var err: Error?
        singIn(sut: sut)

        let path: String = "timeSlots"
        let exp = expectation(description: "Wait for firebase")
        
        func getTimeSlot(from path: String){
            Firestore.firestore().collection(path).getDocuments() { (qerySnapshot, error) in
                err = error
                if err != nil {
                    print("Error getting documents:\(err!)")
                } else {
                    for document in qerySnapshot!.documents {
                        print("***********************\(document.documentID) => \(document.data())")
                    }
                }
                exp.fulfill()
            }
        }
        
        getTimeSlot(from: path)
        
        wait(for: [exp], timeout: 1)
        XCTAssertNil(err)
    }
    
    func test_getTimeSlot_isNotSusccesfullWithNoSession() {
        let sut = makeSUT()
        var err: Error?
        let path: String = "timeSlots"
        let exp = expectation(description: "Wait for firebase")
        
        signOut(sut: sut)
        XCTAssertNil(sut.session)
        
        func getTimeSlot(from path: String){
            Firestore.firestore().collection(path).getDocuments() { (qerySnapshot, error) in
                err = error
                if err != nil {
                    print("Error getting documents:\(err!)")
                } else {
                    for document in qerySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
                exp.fulfill()
            }
        }
        
        getTimeSlot(from: path)
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertNotNil(err)
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
        sut.singOut()
        
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
