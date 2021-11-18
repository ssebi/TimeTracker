
public protocol TimeSlotsPublisher {
	typealias Result = (Swift.Result<TimeSlot, Error>) -> Void

    func addTimeSlots(timeSlot: TimeSlot, to path: String, completion: @escaping Result)
}
