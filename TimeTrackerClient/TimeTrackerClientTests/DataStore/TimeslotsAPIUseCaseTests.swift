
import XCTest
import TimeTrackerClient

class TimeslotsStore {

	typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void

	var getTimeslotsCallCount = 0

	func getTimeslots(completion: GetTimeslotsResult) {
		getTimeslotsCallCount += 1
	}

	func completeGetTimeslots(with error: Error) {

	}

}

class TimeslotsLoader {

	let store: TimeslotsStore

	var timeslots: [TimeSlot] = []

	init(store: TimeslotsStore) {
		self.store = store
	}

	func getTimeslots() {
		store.getTimeslots { result in

		}
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

	func test_getTimeslots_deliversEmptyResultsOnError() {
		let store = TimeslotsStore()
		let sut = TimeslotsLoader(store: store)
		let anyError = NSError(domain: "any error", code: 0)

		sut.getTimeslots()
		store.completeGetTimeslots(with: anyError)

		XCTAssertEqual(sut.timeslots, [])
	}

}
