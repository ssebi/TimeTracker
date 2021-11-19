
public protocol TimeSlotsLoader {
	typealias Result = (Swift.Result<[TimeSlot], Error>) -> Void

	func getTimeSlots(for user: String, with client: Int, and project: Int, completion: @escaping Result)
}


/// ============================= REFACTOR =====================================


public protocol TimeslotsLoader {
	typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void

	var store: TimeslotsStore { get }

	func getTimeslots(completion: @escaping GetTimeslotsResult)

}

public class RemoteTimeslotsLoader: TimeslotsLoader {

	public let store: TimeslotsStore

	public init(store: TimeslotsStore) {
		self.store = store
	}

	public func getTimeslots(completion: @escaping TimeslotsStore.GetTimeslotsResult) {
		store.getTimeslots { [weak self] result in
			guard self != nil else { return }
			completion(result)
		}
	}

}
