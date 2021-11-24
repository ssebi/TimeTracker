
import XCTest
import TimeTrackerClient

class TimeslotsStoreSpy {
	private(set) var addTimeslotsCallCount = 0

	func addTimeSlot(timeSlot: TimeSlot) {
		addTimeslotsCallCount += 1
	}
}

class RemoteTimeSlotsPublisher {
	let store: TimeslotsStoreSpy

	init(store: TimeslotsStoreSpy) {
		self.store = store
	}

	func addTimeSlot(timeSlot: TimeSlot) {
		store.addTimeSlot(timeSlot: timeSlot)
	}
}

class PublishTimeslotUseCaseTests: XCTestCase {

	func test_init_doesNotMessageStore() {
		let store = TimeslotsStoreSpy()
		let _ = RemoteTimeSlotsPublisher(store: store)

		XCTAssertEqual(store.addTimeslotsCallCount, 0)
	}

	func test_addTimeSlot_callsPublisher() {
		let store = TimeslotsStoreSpy()
		let sut = RemoteTimeSlotsPublisher(store: store)

		sut.addTimeSlot(timeSlot: someTimeSlot)

		XCTAssertEqual(store.addTimeslotsCallCount, 1)
	}

	// MARK: - Helpers

	private lazy var someTimeSlot = TimeSlot(id: "1234", userId: "xxx", clientId: 1, projectId: 1, date: Date(), details: TimeSlotDetails(start: Date(), end: Date(), description: "description"), total: 1)

}
