
public protocol TimeslotsStore {

	typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void

	func getTimeslots(completion: @escaping GetTimeslotsResult)

}
