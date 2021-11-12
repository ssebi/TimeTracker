//
//  DataStoreTests.swift
//  TimeTrackerClientTests
//
//  Created by VSebastian on 11.11.2021.
//

import XCTest
@testable import TimeTrackerClient

class DataStore {
    private let clientLoader: ClientsLoader
    private let timeslotsLoader: TimeSlotsLoader
    private let timeslotsPublisher: TimeSlotsPublisher
    private let userLoader: UserLoader

    init(clientLoader: ClientsLoader, timeslotsLoader: TimeSlotsLoader, timeslotsPublisher: TimeSlotsPublisher, userLoader: UserLoader) {
		self.clientLoader = clientLoader
		self.timeslotsLoader = timeslotsLoader
		self.timeslotsPublisher = timeslotsPublisher
        self.userLoader = userLoader
    }

    func getTimeSlots() -> [TimeSlot] {
		timeslotsLoader.getTimeSlots(for: clientLoader.getClients())
	}

	func addTimeSlot(timeSlotCount: Int) -> Int {
		timeslotsPublisher.addTimeSlots(timeSlotCount: timeSlotCount)
	}

    func getUser() -> User {
        userLoader.getUser()
    }
}

class DataStoreTests: XCTestCase {

	func test_init() {
		let sut = makeSut()
		XCTAssertNotNil(sut)
	}

    func test_getTimeSlots_callsGetClientsFromClientsLoader() {
        let (clientSpy, _, _, sut) = makeSut()

		_ = sut.getTimeSlots()

		XCTAssertEqual(clientSpy.getCLientsCalls, 1)
    }

	func test_getTimeSlots_sendsClientsFromClientsLoader() {
		let (clientsSpy, timeSlotsSpy, _, sut) = makeSut()
		let clients = ["Client1", "Client2"]

		clientsSpy.completeGetClientsWith(clients)
		_ = sut.getTimeSlots()

		XCTAssertEqual(timeSlotsSpy.clients, clients)
	}

    func test_addTimeSlot() {
        let (_, _, _, sut) = makeSut()
        let timeSlotCount = 3
        let timeSlot = sut.addTimeSlot(timeSlotCount: timeSlotCount)

        XCTAssertEqual(timeSlotCount, timeSlot)
    }

	// MARK: - Helpers

	private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (ClientsLoaderSpy, TimeSlotsLoaderSpy, TimeSlotPublisherSpy, DataStore) {
		let clientsSpy = ClientsLoaderSpy()
		let timeslotsSpy = TimeSlotsLoaderSpy()
        let spy = TimeSlotPublisherSpy()
        let sut = DataStore(clientLoader: clientsSpy, timeslotsLoader: timeslotsSpy, timeslotsPublisher: spy)
        addTeardownBlock { [weak spy, weak sut] in
            XCTAssertNil(spy, file: file, line: line)
            XCTAssertNil(sut, file: file, line: line)
        }
        return (clientsSpy, timeslotsSpy, spy, sut)
    }
}

