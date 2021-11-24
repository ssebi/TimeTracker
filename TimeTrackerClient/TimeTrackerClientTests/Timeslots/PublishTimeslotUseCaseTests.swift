
import XCTest
import TimeTrackerClient

private class TimeslotsStoreSpy: TimeslotsStore {
	var addTimeslotsCallCount: Int {
		completions.count
	}
	private var completions: [(Error?) -> Void] = []

	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
		
	}

	func addTimeSlot(timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) {
		completions.append(completion)
	}

	func completeAddTimeSlots(with error: Error, at index: Int = 0) {
		completions[index](error)
	}

	func completeAddTimeSlotsWithSuccess(at index: Int = 0) {
		completions[index](nil)
	}
}

private protocol TimeSlotsPublisher {
	var store: TimeslotsStore { get }

	func addTimeSlot(timeSlot: TimeSlot, completion: @escaping (Error?) -> Void)
}


private class RemoteTimeSlotsPublisher: TimeSlotsPublisher {
	let store: TimeslotsStore

	init(store: TimeslotsStoreSpy) {
		self.store = store
	}

	func addTimeSlot(timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) {
		store.addTimeSlot(timeSlot: timeSlot, completion: completion)
	}
}

class PublishTimeslotUseCaseTests: XCTestCase {

	func test_init_doesNotMessageStore() {
		let (_, store) = makeSUT()

		XCTAssertEqual(store.addTimeslotsCallCount, 0)
	}

	func test_addTimeSlot_callsPublisher() {
		let (sut, store) = makeSUT()

		sut.addTimeSlot(timeSlot: someTimeSlot) { _ in }

		XCTAssertEqual(store.addTimeslotsCallCount, 1)
	}

	func test_addTimeSlot_deliversErrorOnPublisherError() {
		let (sut, store) = makeSUT()
		var receivedError: Error?

		receivedError = resultFor(sut: sut, addTimeSlot: someTimeSlot) {
			store.completeAddTimeSlots(with: someError)
		}

		XCTAssertNotNil(receivedError)
		XCTAssertEqual(someError.domain, (receivedError as NSError?)?.domain)
		XCTAssertEqual(someError.code, (receivedError as NSError?)?.code)
	}

	func test_addTimeSlot_deliversSuccessOnPublisherSuccess() throws {
		let (sut, store) = makeSUT()
		var receivedError: Error?

		receivedError = resultFor(sut: sut, addTimeSlot: someTimeSlot) {
			store.completeAddTimeSlotsWithSuccess()
		}

		XCTAssertNil(receivedError)
	}

	// MARK: - Helpers

	private func makeSUT() -> (TimeSlotsPublisher, TimeslotsStoreSpy) {
		let store = TimeslotsStoreSpy()
		let sut = RemoteTimeSlotsPublisher(store: store)

		return (sut, store)
	}

	private func resultFor(sut: TimeSlotsPublisher, addTimeSlot timeSlot: TimeSlot, when action: () -> Void) -> Error? {
		let exp = expectation(description: "Wait for completion")
		var receivedResult: Error?
		sut.addTimeSlot(timeSlot: timeSlot) { result in
			receivedResult = result
			exp.fulfill()
		}
		action()
		wait(for: [exp], timeout: 0.1)
		return receivedResult
	}

	private lazy var someError = NSError(domain: "Test", code: 0)
	private lazy var someTimeSlot = TimeSlot(id: "1234", userId: "xxx", clientId: 1, projectId: 1, date: Date(), details: TimeSlotDetails(start: Date(), end: Date(), description: "description"), total: 1)

}
