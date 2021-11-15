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
        let user = userLoader.getUser()
        let timeslot = timeslotsLoader.getTimeSlots(for: user.uid!)
        return timeslot
	}

    func getClients() -> [String] {
        clientLoader.getClients()
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

    func test_getClients_callsGetClientsFromClientsLoader() {
        let (clientSpy, _, _, _, sut) = makeSut()

		_ = sut.getClients()

        XCTAssertEqual(clientSpy.getClientsCalls, 1)
    }

	func test_getClients_sendsClientsFromClientsLoader() {
        let (clientsSpy, _, _, _, sut) = makeSut()
		let clients = ["Client1", "Client2"]

		clientsSpy.completeGetClientsWith(clients)
		_ = sut.getClients()

        XCTAssertEqual(clientsSpy.getClients(), clients)
	}

    func test_addTimeSlot() {
        let (_, _, _, _, sut) = makeSut()
        let timeSlotCount = 3
        let timeSlot = sut.addTimeSlot(timeSlotCount: timeSlotCount)

        XCTAssertEqual(timeSlotCount, timeSlot)
    }

    func test_getTimeslot_sendsTimeSlotsFromTimeSlotsLoader() {
        let (_, timeSlotsSpy, _, _, sut) = makeSut()
        let userId = "xxx"
        let timeSlotsDetail = TimeSlotDetail(start: Date(), end: Date(), description: "Description t1")
        let timeSlots: [TimeSlot] = [TimeSlot(id: "1234", timeSlots: timeSlotsDetail, total: 10)]

        timeSlotsSpy.completeGetTimeslots(with: timeSlots)
        _ = sut.getTimeSlots()

        XCTAssertEqual(timeSlotsSpy.getTimeSlots(for: userId), timeSlots)
    }

	// MARK: - Helpers

	private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (ClientsLoaderSpy, TimeSlotsLoaderSpy, TimeSlotPublisherSpy, UserLoaderSpy, DataStore) {
		let clientsSpy = ClientsLoaderSpy()
		let timeslotsSpy = TimeSlotsLoaderSpy()
        let spy = TimeSlotPublisherSpy()
        let userSpy = UserLoaderSpy()

        let sut = DataStore(clientLoader: clientsSpy, timeslotsLoader: timeslotsSpy, timeslotsPublisher: spy, userLoader: userSpy)
        addTeardownBlock { [weak spy, weak sut] in
            XCTAssertNil(spy, file: file, line: line)
            XCTAssertNil(sut, file: file, line: line)
        }
        return (clientsSpy, timeslotsSpy, spy, userSpy, sut )
    }
}

