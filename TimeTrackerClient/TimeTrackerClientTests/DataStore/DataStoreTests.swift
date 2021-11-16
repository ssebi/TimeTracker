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

	func getTimeSlots(for id: String, completion: @escaping TimeSlotsLoader.Result) {
        let user = userLoader.getUser()
        timeslotsLoader.getTimeSlots(for: user.uid!, completion: completion)
	}

	func getClients(completion: @escaping ClientsLoader.Result) {
        clientLoader.getClients(completion: completion)
    }

	func addTimeSlot(timeSlot: TimeSlot, completion: @escaping TimeSlotsPublisher.Result) {
		timeslotsPublisher.addTimeSlots(timeSlot: timeSlot, completion: completion)
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

	func test_getClients_returnsFailureOnLoaderError() {
		let (clientSpy, _, _, _, sut) = makeSut()
		let someError = NSError(domain: "test", code: 0)

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
		let someClients = [Client(id: Int.random(in: 0...100), name: "Client1", projects: []),
						   Client(id: Int.random(in: 0...100), name: "Client2", projects: [])]
		var receivedClients: [Client]? = nil

		let result = resultFor(sut: sut, when: {
			clientSpy.completeGetClients(with: someClients)
		})

		receivedClients = try result.get()
		XCTAssertEqual(receivedClients, someClients)
	}

	func test_addTimeSlot_callsPublisher() {
		let (_, _, timeslotsSpy, _, sut) = makeSut()
        let timeSlotsDetail = TimeSlotDetail(start: Date(), end: Date(), description: "Description t1")
        let newTimeSlot = TimeSlot(id: "1234", timeSlots: timeSlotsDetail, total: 10)

        sut.addTimeSlot(timeSlot: newTimeSlot) { _ in }

        XCTAssertEqual(timeslotsSpy.timeslotCalls, 1)
	}

	func test_addTimeSlot_deliversErrorOnPublisherError() {
        let (_, _, timeslotsSpy, _, sut) = makeSut()
        let someError = NSError(domain: "test", code: 0)
        let timeSlotsDetail = TimeSlotDetail(start: Date(), end: Date(), description: "Description t1")
        let newTimeSlot = TimeSlot(id: "1234", timeSlots: timeSlotsDetail, total: 10)

        let result = resultFor(sut: sut, addTimeSlot: newTimeSlot, when: {
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

    func test_addTimeSlot_deliversSuccessOnPublisherSuccess() {
        let (_, _, timeslotSpy, _, sut) = makeSut()
        let timeSlotsDetail = TimeSlotDetail(start: Date(), end: Date(), description: "Description t1")
        let newTimeSlot = TimeSlot(id: "1234", timeSlots: timeSlotsDetail, total: 10)
        var receivedTimeslot: TimeSlot? = nil

        let result = resultFor(sut: sut, addTimeSlot: newTimeSlot, when: {
            timeslotSpy.completeAddTimeSlots(with: newTimeSlot)
        })

        receivedTimeslot = try? result.get()
        XCTAssertEqual(receivedTimeslot, newTimeSlot)
    }

	func test_getTimeslot_callsLoader() {
		// TODO: -
		/// testeaza ca `TimeSlotsLoaderSpy.getTimeSlotsCalls` e 1
		XCTFail()
	}

	func test_getTimeSlot_getTimeSlotForTheCorectUserId() {
		// TODO: -
		/// aici testeaza doar ca `TimeSlotsLoaderSpy.userID` se pupa cu id-ul pe care-l trimiti pe `getTimeSlots`
		XCTFail()
	}

	func test_getTimeslot_deliversErrorOnLoaderFailure() {
		// TODO: -
		/// foloseste-te de `resultFor` si verifica daca pe `completeWithError` returneaza eroare
		XCTFail()
	}

	func test_getTimeslot_deliversResultsOnLoaderSuccess() {
		let timeSlotsDetail = TimeSlotDetail(start: Date(), end: Date(), description: "Description t1")
		let timeSlots: [TimeSlot] = [TimeSlot(id: "1234", timeSlots: timeSlotsDetail, total: 10)]
		// TODO: -
		/// foloseste-te de `resultFor` si verifica daca pe `completeWithSuccess` returneaza `[TimeSlot]`
		XCTFail()
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
		sut.addTimeSlot(timeSlot: timeSlot) { result in
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
		sut.getTimeSlots(for: userID) { result in
			receivedResult = result
			exp.fulfill()
		}
		action()
		wait(for: [exp], timeout: 0.1)
		return receivedResult!
	}

}

