
import XCTest

class TimeslotsStore {
	var getTimeslotsCallCount = 0

	func getTimeslots() {
		getTimeslotsCallCount += 1
	}
}

class TimeslotsLoader {
	let store: TimeslotsStore

	init(store: TimeslotsStore) {
		self.store = store
	}

	func getTimeslots() {
		store.getTimeslots()
	}
}

class TimeslotsAPIUseCaseTests: XCTestCase {

	func test_init_doesNotMessageStore() {
		let store = TimeslotsStore()
		let _ = TimeslotsLoader(store: store)

		XCTAssertEqual(store.getTimeslotsCallCount, 0)
	}

	func test_getTimeslots_callsStore() {
		let store = TimeslotsStore()
		let sut = TimeslotsLoader(store: store)

		sut.getTimeslots()

		XCTAssertEqual(store.getTimeslotsCallCount, 1)
	}

}
