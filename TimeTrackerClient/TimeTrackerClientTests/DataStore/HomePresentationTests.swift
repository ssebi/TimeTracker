
import XCTest
import TimeTrackerClient

class MockStore: TimeslotsStore {

	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
		completion(.success([]))
	}

}

class TimeslotsLoaderSpy: TimeslotsLoader {
	private(set) var store: TimeslotsStore

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

class HomeScreenViewModel {

	private let timeslotsLoader: TimeslotsLoader
	@Published private(set) var timeslots: [TimeSlot] = []

	init(timeslotsLoader: TimeslotsLoader) {
		self.timeslotsLoader = timeslotsLoader
		setup()
	}

	private func setup() {
		timeslotsLoader.getTimeslots(userID: "YErySzP9KBgMsFw64rHrimFAUBZ2") { result in
			self.timeslots = (try? result.get()) ?? []

		}
	}

}

class HomePresentationTests: XCTestCase {

	func test_init_callsLoadTimeslots() {
		let store = MockStore()
		let loader = TimeslotsLoaderSpy(store: store)
		let _ = HomeScreenViewModel(timeslotsLoader: loader)

		XCTAssertEqual(loader.getTimeslotsCallCount, 1)
	}

	func test_setup_storesTimeslotsOnSuccess() {
		let store = MockStore()
		let loader = TimeslotsLoaderSpy(store: store)
		let sut = HomeScreenViewModel(timeslotsLoader: loader)
		let timeslots = uniqueTimeslots

		loader.completeLoadTimeslots(with: timeslots)

		XCTAssertEqual(sut.timeslots, timeslots)
	}

	// MARK: - Helpers

	private var uniqueTimeslots: [TimeSlot] {
		[
			uniqueTimeslot,
			uniqueTimeslot,
		]
	}

	private var uniqueTimeslot: TimeSlot {
		TimeSlot(id: UUID().uuidString,
				 userId: UUID().uuidString,
				 clientId: Int.random(in: 0...100),
				 projectId: Int.random(in: 0...100),
				 date: Date(),
				 timeSlotDetail:
					TimeSlotDetail(
						start: Date(),
						end: Date() + 1000,
						description: "some description"),
				 total: Int.random(in: 0...100))
	}

}
