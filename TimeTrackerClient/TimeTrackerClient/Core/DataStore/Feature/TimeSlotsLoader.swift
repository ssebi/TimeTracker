
public protocol TimeSlotsLoader {
	typealias Result = (Swift.Result<[TimeSlot], Error>) -> Void

	func getTimeSlots(for user: String, completion: @escaping Result)
}
