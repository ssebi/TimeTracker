
import XCTest
@testable import TimeTrackerClient

class TimeslotsUIComposerTests: XCTestCase {

	func test_init_callsLoader() {
		let loader = TimeslotsLoaderSpy(store: MockStore())
		let _ = HomeScreenUIComposer.makeHomeScreen(timeslotsLoader: loader, userLoader: UserLoaderMock())

		XCTAssertEqual(loader.getTimeslotsCallCount, 1)
	}


	private class TimeslotsLoaderSpy: TimeslotsLoader {
		var store: TimeslotsStore

		private(set) var getTimeslotsCallCount = 0

		func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
			getTimeslotsCallCount += 1
		}

		init(store: TimeslotsStore) {
			self.store = store
		}
	}

	private class MockStore: TimeslotsStore {
		func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
			completion(.success([]))
		}
	}

	private class UserLoaderMock: UserLoader {
		func getUser() -> User {
			User(uid: UUID().uuidString, email: "somteEmail@test.com", username: "Test", client: "Client")
		}
	}
}
