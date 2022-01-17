
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
			guard let self = self else { return }
			switch result {
				case let .success(timeslots):
					completion(.success(self.sortedTimeslotsByDateDescending(timeslots)))

				case let .failure(error):
					completion(.failure(error))
			}
		}
	}

	private func sortedTimeslotsByDateDescending(_ timeslots: [TimeSlot]) -> [TimeSlot] {
		timeslots.sorted { $0.date > $1.date }
	}

}
