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
    let clientLoader: ClientsLoader
    let timeslotsLoader: TimeSlotsLoader
    let timeslotsPublisher: TimeSlotsPublisher

    init(clientLoader: ClientsLoader, timeslotsLoader: TimeSlotsLoader, timeslotsPublisher: TimeSlotsPublisher) {
		self.clientLoader = clientLoader
		self.timeslotsLoader = timeslotsLoader
		self.timeslotsPublisher = timeslotsPublisher
    }

	func getTimeSlots() -> [String] {
		timeslotsLoader.getTimeSlots(for: clientLoader.getClients())
	}
}

class DataStoreTests: XCTestCase {

	func test_init() {
		let sut = makeSut()
		XCTAssertNotNil(sut)
	}

    func test_getClients_isCalled() {
        let (spy, sut) = makeClientsLoaderSUT()
        _ = sut.clientLoader.getClients()

		XCTAssertEqual(spy.getCLientsCalls, 1)
    }

    func test_getTimeSlots_callsGetClientsFromClientsLoader() {
        let (clientSpy, _, sut) = makeSut()

		_ = sut.getTimeSlots()

		XCTAssertEqual(clientSpy.getCLientsCalls, 1)
    }

    func test_addTimeSlot() {
        let (_, _, sut) = makeSut()
        let timeSlotCount = 3
        let timeSlot = sut.timeslotsPublisher.addTimeSlots(timeSlotCount: timeSlotCount)

        XCTAssertEqual(timeSlotCount, timeSlot)
    }

	// MARK: - Helpers
	private func makeClientsLoaderSUT() -> (ClientsLoaderSpy, DataStore) {
		let spy = ClientsLoaderSpy()
		let sut = DataStore(clientLoader: spy, timeslotsLoader: TimeSlotsLoaderSpy(), timeslotsPublisher: TimeSlotPublisherSpy())
		return (spy, sut)
	}

    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (ClientsLoaderSpy, TimeSlotPublisherSpy, DataStore) {
		let clientsSpy = ClientsLoaderSpy()
        let spy = TimeSlotPublisherSpy()
        let sut = DataStore(clientLoader: clientsSpy, timeslotsLoader: TimeSlotsLoaderSpy(), timeslotsPublisher: spy)
        addTeardownBlock { [weak spy, weak sut] in
            XCTAssertNil(spy, file: file, line: line)
            XCTAssertNil(sut, file: file, line: line)
        }
        return (clientsSpy, spy, sut)
    }
}

