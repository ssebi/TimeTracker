
import XCTest
import TimeTrackerClient

class TimeslotsStore {

	typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void

	var getTimeslotsCallCount = 0

	private var completions: [GetTimeslotsResult] = []

	func getTimeslots(completion: @escaping GetTimeslotsResult) {
		getTimeslotsCallCount += 1
		completions.append(completion)
	}

	func completeGetTimeslots(with error: Error, at index: Int = 0) {
		completions[index](.failure(error))
	}

	func completeGetTimeslots(with timeslots: [TimeSlot], at index: Int = 0) {
		completions[index](.success(timeslots))
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
			if let timeslots = try? result.get() {
				self.timeslots = timeslots
			}
		}
	}

}

class TimeslotsAPIUseCaseTests: XCTestCase {

	func test_init_doesNotMessageStore() {
		let (store, _) = makeSUT()

		XCTAssertEqual(store.getTimeslotsCallCount, 0)
	}

	func test_getTimeslots_callsStore() {
		let (store, sut) = makeSUT()

		sut.getTimeslots()

		XCTAssertEqual(store.getTimeslotsCallCount, 1)
	}

	func test_getTimeslots_deliversEmptyResultsOnError() {
		let (store, sut) = makeSUT()
		let anyError = NSError(domain: "any error", code: 0)

		sut.getTimeslots()
		store.completeGetTimeslots(with: anyError)

		XCTAssertEqual(sut.timeslots, [])
	}

	func test_getTimeslots_deliversResultsOnSuccess() {
		let (store, sut) = makeSUT()
		let details = TimeSlotDetails(start: "2021-11-22T09:48:51Z",  end: "2021-11-22T09:48:51Z", description: "")
		let timeslots = [TimeSlot(id: "", userId: "", clientId: 1, projectId: 1, date: "2021-11-22T09:48:51Z", details: details, total: 1)]

		sut.getTimeslots()
		store.completeGetTimeslots(with: timeslots)

		XCTAssertEqual(sut.timeslots, timeslots)
	}


	// MARK: - Helpers

	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (TimeslotsStore, TimeslotsLoader) {
		let store = TimeslotsStore()
		let sut = TimeslotsLoader(store: store)

		return (store, sut)
	}

}
