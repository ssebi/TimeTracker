//
//  DataStoreTests.swift
//  TimeTrackerClientTests
//
//  Created by VSebastian on 11.11.2021.
//

import XCTest

protocol TimeSlotsPublisher {
    func addTimeSlots(timeSlotCount: Int) -> Int
}

class TimeSlotPublisherSpy: TimeSlotsPublisher {
    var timeslot = 0
    func addTimeSlots(timeSlotCount: Int) -> Int {
        timeslot += timeSlotCount
        return timeslot
    }
}

class DataStore {
    let clientLoader: ClientsLoaderSpy
    let timeslotsLoader: TimeSlotsLoader
    let timeslotPublisher: TimeSlotsPublisher

    init() {
        clientLoader = ClientsLoaderSpy()
        timeslotsLoader = TimeSlotsLoaderSpy(clients: clientLoader.getClients())
        timeslotPublisher = TimeSlotPublisherSpy()
    }
}

class DataStoreTests: XCTestCase {

	func test_init() {
		let ds = DataStore()
		XCTAssertNotNil(ds)
	}

    func test_getClientNotNil() {
        let (_, sut) = makeSut()
        let clients = sut.clientLoader.getClients()

        XCTAssertNotNil(clients)
    }

    func test_getTimeSlotsNotNil() {
        let (_, sut) = makeSut()
        let timeSlots = sut.timeslotsLoader.getTimeSlots()

        XCTAssertNotNil(timeSlots)
    }

    func test_addTimeSlot() {
        let (_, sut) = makeSut()
        let timeSlotCount = 3
        let timeSlot = sut.timeslotPublisher.addTimeSlots(timeSlotCount: timeSlotCount)

        XCTAssertEqual(timeSlotCount, timeSlot)
    }
    //: Mark Helpers

    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (TimeSlotPublisherSpy, DataStore) {
        let spy = TimeSlotPublisherSpy()
        let sut = DataStore()
        addTeardownBlock { [weak spy, weak sut] in
            XCTAssertNil(spy, file: file, line: line)
            XCTAssertNil(sut, file: file, line: line)
        }
        return (spy, sut)
    }
}

