
public protocol TimeSlotsPublisher {
	typealias Result = (Swift.Result<TimeSlot, Error>) -> Void

	func addTimeSlots(timeSlot: TimeSlot, completion: @escaping Result)
}
