
public protocol TimeslotsStore {

	typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void

	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult)

	func addTimeSlot(timeSlot: TimeSlot, completion: @escaping (Error?) -> Void)

}
