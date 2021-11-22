
import XCTest
import TimeTrackerClient

class HomePresentationTests: XCTestCase {

	func test_init_callsLoadTimeslots() {
		let (_, loader) = makeSUT()

		XCTAssertEqual(loader.getTimeslotsCallCount, 1)
	}

	func test_setup_storesTimeslotsOnSuccess() {
		let (sut, loader) = makeSUT()
		let timeslots = uniqueTimeslots

		loader.completeLoadTimeslots(with: timeslots)

		XCTAssertEqual(sut.timeslots, timeslots)
	}

	// MARK: - Helpers

	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (HomeScreenViewModel, TimeslotsLoaderSpy) {
		let store = MockStore()
		let loader = TimeslotsLoaderSpy(store: store)
		let sut = HomeScreenViewModel(timeslotsLoader: loader, userLoader: UserLoaderMock())

		return (sut, loader)
	}

}
