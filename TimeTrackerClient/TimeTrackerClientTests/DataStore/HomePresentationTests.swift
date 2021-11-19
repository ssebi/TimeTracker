
import XCTest
import TimeTrackerClient

class MockStore: TimeslotsStore {

	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
		completion(.success(uniqueTimeslots))
	}

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

class TimeslotsLoaderSpy: TimeslotsLoader {
	private(set) var store: TimeslotsStore

	private(set) var getTimeslotsCallCount = 0

	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
		getTimeslotsCallCount += 1
	}

	init(store: TimeslotsStore) {
		self.store = store
	}

}

class HomeScreenViewModel {

	private let timeslotsLoader: TimeslotsLoader

	init(timeslotsLoader: TimeslotsLoader) {
		self.timeslotsLoader = timeslotsLoader
		setup()
	}

	private func setup() {
		timeslotsLoader.getTimeslots(userID: "YErySzP9KBgMsFw64rHrimFAUBZ2") { _ in }
	}

}

class HomePresentationTests: XCTestCase {

	func test_init_callsLoadTimeslots() {
		let store = MockStore()
		let loader = TimeslotsLoaderSpy(store: store)
		let _ = HomeScreenViewModel(timeslotsLoader: loader)

		XCTAssertEqual(loader.getTimeslotsCallCount, 1)
	}

	

}
