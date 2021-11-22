
import Combine

public class HomeScreenViewModel: ObservableObject {

	private let timeslotsLoader: TimeslotsLoader
	private let userLoader: UserLoader
	@Published public private(set) var timeslots: [TimeSlot] = []

	public init(timeslotsLoader: TimeslotsLoader, userLoader: UserLoader) {
		self.timeslotsLoader = timeslotsLoader
		self.userLoader = userLoader
		setup()
	}

	private func setup() {
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
