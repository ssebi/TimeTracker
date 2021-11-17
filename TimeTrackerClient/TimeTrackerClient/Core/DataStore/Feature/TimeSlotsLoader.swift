
public protocol TimeSlotsLoader {
	typealias Result = (Swift.Result<[TimeSlot], Error>) -> Void

	func getTimeSlots(for user: String, with client: Int, and project: Int, completion: @escaping Result)
}
