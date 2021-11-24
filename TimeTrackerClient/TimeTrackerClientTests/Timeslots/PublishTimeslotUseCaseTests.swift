
import XCTest

class TimeslotsStoreSpy {
	private(set) var addTimeslotsCallCount = 0
}

class RemoteTimeSlotsPublisher {
	let store: TimeslotsStoreSpy

	init(store: TimeslotsStoreSpy) {
		self.store = store
	}
}

class PublishTimeslotUseCaseTests: XCTestCase {

	func test_init_doesNotMessageStore() {
		let store = TimeslotsStoreSpy()
		let _ = RemoteTimeSlotsPublisher(store: store)

		XCTAssertEqual(store.addTimeslotsCallCount, 0)
	}

}
