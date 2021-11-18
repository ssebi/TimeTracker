//
//  DataStoreTests.swift
//  TimeTrackerClientTests
//
//  Created by VSebastian on 11.11.2021.
//

import XCTest
@testable import TimeTrackerClient

class DataStoreTests: XCTestCase {

    func test_getClients_callsGetClientsFromClientsLoader() {
        let (clientSpy, _, _, _, sut) = makeSut()

		sut.getClients() { _ in }

        XCTAssertEqual(clientSpy.getClientsCalls, 1)
    }

	func test_getClients_returnsFailureOnLoaderError() {
		let (clientSpy, _, _, _, sut) = makeSut()

		let result = resultFor(sut: sut, when: {
			clientSpy.completeGetClients(with: someError)
		})

		switch result {
			case .success:
				XCTFail()
			case .failure(let error):
				XCTAssertEqual(someError.domain, (error as NSError).domain)
				XCTAssertEqual(someError.code, (error as NSError).code)
		}
	}

	func test_getClients_returnsClientsLoaderOnSuccess() throws {
		let (clientSpy, _, _, _, sut) = makeSut()
        let someClients = [Client(id: UUID().uuidString, name: "Client1", projects: []),
						   Client(id: UUID().uuidString, name: "Client2", projects: [])]
		var receivedClients: [Client]? = nil

		let result = resultFor(sut: sut, when: {
			clientSpy.completeGetClients(with: someClients)
		})

		receivedClients = try result.get()
		XCTAssertEqual(receivedClients, someClients)
	}

	func test_addTimeSlot_callsPublisher() {
		let (_, _, timeslotsSpy, _, sut) = makeSut()

        sut.addTimeSlot(timeSlot: someTimeSlot, to: Path.timeSlot) { _ in }

        XCTAssertEqual(timeslotsSpy.timeslotCalls, 1)
	}

	func test_addTimeSlot_deliversErrorOnPublisherError() {
        let (_, _, timeslotsSpy, _, sut) = makeSut()

        let result = resultFor(sut: sut, addTimeSlot: someTimeSlot, when: {
            timeslotsSpy.completeAddTimeSlots(with: someError)
        })

        switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(someError.domain, (error as NSError).domain)
                XCTAssertEqual(someError.code, (error as NSError).code)
        }
	}

    func test_addTimeSlot_deliversSuccessOnPublisherSuccess() throws {
        let (_, _, timeslotSpy, _, sut) = makeSut()
        var receivedTimeslot: TimeSlot?

        let result = resultFor(sut: sut, addTimeSlot: someTimeSlot, when: {
            timeslotSpy.completeAddTimeSlots(with: someTimeSlot)
        })

        receivedTimeslot = try result.get()
        XCTAssertEqual(receivedTimeslot, someTimeSlot)
    }

	func test_getTimeslot_callsLoader() {
        let (_, timeslotSpy, _, _, sut) = makeSut()

        sut.getTimeSlots(for: "xxx", with: 1, and: 1,  completion: {_ in })

        XCTAssertEqual(timeslotSpy.getTimeSlotsCalls, 1)
	}

	func test_getTimeSlot_getTimeSlotForTheCorectUserId() {
        let (_, timeslotSpy, _, _, sut) = makeSut()
        let userId = "xxx"

        sut.getTimeSlots(for: userId, with: 1, and: 1, completion: {_ in })

        XCTAssertEqual(timeslotSpy.userId, userId)
	}

	func test_getTimeslot_deliversErrorOnLoaderFailure() {
        let (_, timeslotSpy, _, _, sut) = makeSut()

        let result = resultFor(sut: sut, userID: "xxx", when: {
            timeslotSpy.completeGetTimeslots(with: someError)
        })

        switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(someError.domain, (error as NSError).domain)
                XCTAssertEqual(someError.code, (error as NSError).code)
        }
	}

	func test_getTimeslot_deliversResultsOnLoaderSuccess() throws {
        let (_, timeslotSpy, _, _, sut) = makeSut()

        let result = resultFor(sut: sut, userID: "xxx", when: {
            timeslotSpy.completeGetTimeslots(with: [someTimeSlot])
        })

		let receivedTimeslots = try result.get()
		XCTAssertEqual([someTimeSlot], receivedTimeslots)
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

	private lazy var someError = NSError(domain: "Test", code: 0)
    private lazy var someTimeSlot = TimeSlot(id: "1234", userId: "xxx", clientId: 1, projectId: 1, date: Date(), timeSlotDetail: TimeSlotDetail(start: Date(), end: Date(), description: "Description t1"), total: 10)

	private func resultFor(sut: DataStore, when action: () -> Void) -> Result<[Client], Error> {
		let exp = expectation(description: "Wait for completion")
		var receivedResult: Result<[Client], Error>?
		sut.getClients() { result in
			receivedResult = result
			exp.fulfill()
		}
		action()
		wait(for: [exp], timeout: 0.1)
		return receivedResult!
	}

	private func resultFor(sut: DataStore, addTimeSlot timeSlot: TimeSlot, when action: () -> Void) -> Result<TimeSlot, Error> {
		let exp = expectation(description: "Wait for completion")
		var receivedResult: Result<TimeSlot, Error>?
        sut.addTimeSlot(timeSlot: timeSlot, to: Path.timeSlot) { result in
			receivedResult = result
			exp.fulfill()
		}
		action()
		wait(for: [exp], timeout: 0.1)
		return receivedResult!
	}

	private func resultFor(sut: DataStore, userID: String, when action: () -> Void) -> Result<[TimeSlot], Error> {
		let exp = expectation(description: "Wait for completion")
		var receivedResult: Result<[TimeSlot], Error>?
        sut.getTimeSlots(for: userID, with: 1, and: 1) { result in
			receivedResult = result
			exp.fulfill()
		}
		action()
		wait(for: [exp], timeout: 0.1)
		return receivedResult!
	}

}

