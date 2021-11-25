
import XCTest
@testable import TimeTrackerClient

class PublishTimeslotUseCaseTests: XCTestCase {

	func test_init_doesNotMessageStore() {
		let (_, store) = makeSUT()

		XCTAssertEqual(store.addTimeslotsCallCount, 0)
	}

	func test_addTimeSlot_callsPublisher() {
		let (sut, store) = makeSUT()

		sut.addTimeSlot(someTimeSlot) { _ in }

		XCTAssertEqual(store.addTimeslotsCallCount, 1)
	}

	func test_addTimeSlot_deliversErrorOnPublisherError() {
		let (sut, store) = makeSUT()
		var receivedError: Error?

		receivedError = resultFor(sut: sut, addTimeSlot: someTimeSlot) {
			store.completeAddTimeSlots(with: anyError)
		}

		XCTAssertNotNil(receivedError)
		XCTAssertEqual(anyError.domain, (receivedError as NSError?)?.domain)
		XCTAssertEqual(anyError.code, (receivedError as NSError?)?.code)
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
		sut.addTimeSlot(timeSlot) { result in
			receivedResult = result
			exp.fulfill()
		}
		action()
		wait(for: [exp], timeout: 0.1)
		return receivedResult
	}

	private lazy var someTimeSlot = TimeSlot(id: "1234", userId: "xxx", clientId: 1, projectId: 1, date: Date(), details: TimeSlotDetails(start: Date(), end: Date(), description: "description"), total: 1)

}
