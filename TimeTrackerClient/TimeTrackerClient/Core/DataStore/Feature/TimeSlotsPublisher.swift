
public protocol TimeSlotsPublisher {

	var store: TimeslotsStore { get }

	func addTimeSlot(_ timeSlot: TimeSlot, completion: @escaping (Error?) -> Void)

}


class RemoteTimeSlotsPublisher: TimeSlotsPublisher {
	let store: TimeslotsStore

	init(store: TimeslotsStore) {
		self.store = store
	}

	func addTimeSlot(_ timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) {
		store.addTimeSlot(timeSlot: timeSlot, completion: completion)
	}
}
