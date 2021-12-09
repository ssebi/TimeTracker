
import Combine
import Foundation

public class HomeScreenViewModel: ObservableObject {

	private let timeslotsLoader: TimeslotsLoader
	private let userLoader: UserLoader
	@Published public private(set) var timeslots: [TimeSlot] = []
    let dateFormater = DateFormatter()

    var categories: [String:[TimeSlot]] {
        Dictionary(grouping: timeslots, by:{ $0.sortDate })
    }

	public init(timeslotsLoader: TimeslotsLoader, userLoader: UserLoader) {
		self.timeslotsLoader = timeslotsLoader
		self.userLoader = userLoader
	}

	func refresh() {
		guard let userID = userLoader.getUser().uid else {
			return
		}
		timeslotsLoader.getTimeslots(userID: userID) { [weak self] result in
			guard let self = self else {
				return
			}
			self.timeslots = (try? result.get()) ?? []
		}
	}
}

private extension TimeSlot {
    var sortDate: String {
        let dateComp = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let date = Calendar.current.date(from: dateComp) ?? Date.distantFuture

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd-MMMM-yyyy"
        return dateFormatter.string(from: date)
    }
}
