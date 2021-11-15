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

    func getTimeSlots(for id: String) -> [TimeSlot]? {
        let user = userLoader.getUser()
        let timeslot = user.uid == id ? timeslotsLoader.getTimeSlots(for: user.uid!) : nil

        return timeslot
	}

	func getClients(completion: @escaping ClientsLoader.Result) {
        clientLoader.getClients(completion: completion)
    }

	func addTimeSlot(timeSlot: TimeSlot) -> TimeSlot {
		timeslotsPublisher.addTimeSlots(timeSlot: timeSlot)
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

		sut.getClients() { _ in }

        XCTAssertEqual(clientSpy.getClientsCalls, 1)
    }

	func test_getClients_returnsClientsOnSuccess() {
		let (clientSpy, _, _, _, sut) = makeSut()
		let someClients = [Client(id: Int.random(in: 0...100), name: "Client1", projects: []),
						   Client(id: Int.random(in: 0...100), name: "Client2", projects: [])]
		var receivedClients: [Client]? = nil

		let exp = expectation(description: "Wait for completion")
		sut.getClients() { result in
			if let clients = try? result.get() {
				receivedClients = clients
			}
			exp.fulfill()
		}
		clientSpy.completeGetClientsWith(someClients)
		wait(for: [exp], timeout: 0.1)

		XCTAssertEqual(receivedClients, someClients)
	}

    func test_addTimeSlot() {
        let (_, _, _, _, sut) = makeSut()
        let timeSlotsDetail = TimeSlotDetail(start: Date(), end: Date(), description: "Description t1")
        let newTimeSlot: TimeSlot = TimeSlot(id: "1234", timeSlots: timeSlotsDetail, total: 10)
        let adedTimeSlot = sut.addTimeSlot(timeSlot: newTimeSlot)

        XCTAssertEqual(adedTimeSlot, newTimeSlot)
    }

    func test_getTimeslot_sendsTimeSlotsFromTimeSlotsLoader() {
        let (_, timeSlotsSpy, _, _, sut) = makeSut()
        let userId = "xxx"
        let timeSlotsDetail = TimeSlotDetail(start: Date(), end: Date(), description: "Description t1")
        let timeSlots: [TimeSlot] = [TimeSlot(id: "1234", timeSlots: timeSlotsDetail, total: 10)]

        timeSlotsSpy.completeGetTimeslots(with: timeSlots)
        _ = sut.getTimeSlots(for: userId)

        XCTAssertEqual(timeSlotsSpy.getTimeSlots(for: userId), timeSlots)
    }

    func test_getTimeSlot_getTimeSlotForTheCorectUserId() {
        let (_, timeSlotsSpy, _, _, sut) = makeSut()
        let userId = "xxx"
        let timeSlotsDetail = TimeSlotDetail(start: Date(), end: Date(), description: "Description t1")
        let timeSlots: [TimeSlot] = [TimeSlot(id: "1234", timeSlots: timeSlotsDetail, total: 10)]

        timeSlotsSpy.completeGetTimeslots(with: timeSlots)
        let ts = sut.getTimeSlots(for: userId)

        XCTAssertNotNil(ts)
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

