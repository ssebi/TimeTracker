
import XCTest
import TimeTrackerClient

class HomePresentationTests: XCTestCase {

	func test_init_callsLoadTimeslots() {
		let store = MockStore()
		let loader = TimeslotsLoaderSpy(store: store)
		let _ = HomeScreenViewModel(timeslotsLoader: loader, userLoader: UserLoaderMock())

		XCTAssertEqual(loader.getTimeslotsCallCount, 1)
	}

	func test_setup_storesTimeslotsOnSuccess() {
		let store = MockStore()
		let loader = TimeslotsLoaderSpy(store: store)
		let sut = HomeScreenViewModel(timeslotsLoader: loader, userLoader: UserLoaderMock())
		let timeslots = uniqueTimeslots

		loader.completeLoadTimeslots(with: timeslots)

		XCTAssertEqual(sut.timeslots, timeslots)
	}

}
