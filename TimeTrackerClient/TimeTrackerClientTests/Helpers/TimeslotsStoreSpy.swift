
import TimeTrackerClient

class TimeslotsStoreSpy: TimeslotsStore {

	var getTimeslotsCallCount: Int {
		getTimeslotsCompletions.count
	}
	var addTimeslotsCallCount: Int {
		addTimeslotsCompletions.count
	}

	private var getTimeslotsCompletions: [GetTimeslotsResult] = []
	private var addTimeslotsCompletions: [(Error?) -> Void] = []


	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
		getTimeslotsCompletions.append(completion)
	}

	func addTimeSlot(timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) {
		addTimeslotsCompletions.append(completion)
	}

	func completeGetTimeslots(with error: Error, at index: Int = 0) {
		getTimeslotsCompletions[index](.failure(error))
	}

	func completeGetTimeslots(with timeslots: [TimeSlot], at index: Int = 0) {
		getTimeslotsCompletions[index](.success(timeslots))
	}

	func completeAddTimeSlots(with error: Error, at index: Int = 0) {
		addTimeslotsCompletions[index](error)
	}

	func completeAddTimeSlotsWithSuccess(at index: Int = 0) {
		addTimeslotsCompletions[index](nil)
	}

}
