
import TimeTrackerClient

class MockStore: TimeslotsStore {

	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
		completion(.success([]))
	}

	func addTimeSlot(timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) {
		completion(nil)
	}
	
}
