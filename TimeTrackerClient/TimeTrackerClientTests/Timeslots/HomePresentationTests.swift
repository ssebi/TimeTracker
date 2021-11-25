
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

		trackForMemoryLeaks(store, file: file, line: line)
		trackForMemoryLeaks(loader, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)

		return (sut, loader)
	}

	private class TimeslotsLoaderSpy: TimeslotsLoader {
		let store: TimeslotsStore

		private(set) var getTimeslotsCallCount = 0
		private var completions: [GetTimeslotsResult] = []

		func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
			getTimeslotsCallCount += 1
			completions.append(completion)
		}

		init(store: TimeslotsStore) {
			self.store = store
		}

		func completeLoadTimeslots(with timeslots: [TimeSlot], at index: Int = 0) {
			completions[index](.success(timeslots))
		}

	}

}
