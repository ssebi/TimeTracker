
import TimeTrackerClient

class MockStore: TimeslotsStore {

	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
		completion(.success([]))
	}
	
}
