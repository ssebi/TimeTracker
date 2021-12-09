
import Combine
import Foundation

public class HomeScreenViewModel: ObservableObject {

	private let timeslotsLoader: TimeslotsLoader
	private let userLoader: UserLoader
	@Published public private(set) var timeslots: [TimeSlot] = []
    let dateFormatter = DateFormatter()
    
    var categories: [Date:[TimeSlot]] {
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
    var sortDate: Date {
        let dateComp = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let date = Calendar.current.date(from: dateComp) ?? Date.distantFuture
        return date
    }
}
