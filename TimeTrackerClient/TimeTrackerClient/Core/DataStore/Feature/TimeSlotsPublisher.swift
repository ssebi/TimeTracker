
public protocol TimeSlotsPublisher {

	var store: TimeslotsStore { get }

	func addTimeSlot(_ timeSlot: TimeSlot, completion: @escaping (Error?) -> Void)

}


public class RemoteTimeSlotsPublisher: TimeSlotsPublisher {
	public let store: TimeslotsStore

	public init(store: TimeslotsStore) {
		self.store = store
	}

	public func addTimeSlot(_ timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) {
		store.addTimeSlot(timeSlot: timeSlot, completion: completion)
	}
}
