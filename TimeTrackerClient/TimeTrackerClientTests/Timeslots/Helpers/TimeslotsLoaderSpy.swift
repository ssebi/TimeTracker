
import TimeTrackerClient

class TimeslotsLoaderSpy: TimeslotsLoader {
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
