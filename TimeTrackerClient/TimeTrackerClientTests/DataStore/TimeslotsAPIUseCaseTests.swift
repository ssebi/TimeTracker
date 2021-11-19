
import XCTest

class TimeslotsStore {
	let getTimeslotsCallCount = 0
}

class TimeslotsLoader {
	let store: TimeslotsStore

	init(store: TimeslotsStore) {
		self.store = store
	}
}

class TimeslotsAPIUseCaseTests: XCTestCase {

	func test_init_doesNotMessageStore() {
		let store = TimeslotsStore()
		let _ = TimeslotsLoader(store: store)

		XCTAssertEqual(store.getTimeslotsCallCount, 0)
	}

}
