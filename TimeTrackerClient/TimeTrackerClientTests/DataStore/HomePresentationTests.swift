
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
				 details:
					TimeSlotDetails(
						start: Date(),
						end: Date(),
						description: "some description"),
				 total: Int.random(in: 0...100))
	}

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

	private class UserLoaderMock: UserLoader {
		func getUser() -> User {
			User(uid: UUID().uuidString, email: "somteEmail@test.com", username: "Test", client: "Client")
		}
	}

}
