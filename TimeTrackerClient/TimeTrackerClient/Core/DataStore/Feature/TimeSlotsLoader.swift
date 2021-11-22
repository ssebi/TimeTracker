
public protocol TimeslotsLoader {
	typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void

	var store: TimeslotsStore { get }

	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult)

}

public class RemoteTimeslotsLoader: TimeslotsLoader {

	public let store: TimeslotsStore

	public init(store: TimeslotsStore) {
		self.store = store
	}

	public func getTimeslots(userID: String, completion: @escaping TimeslotsStore.GetTimeslotsResult) {
		store.getTimeslots(userID: userID) { [weak self] result in
			guard self != nil else { return }
			completion(result)
		}
	}

}
