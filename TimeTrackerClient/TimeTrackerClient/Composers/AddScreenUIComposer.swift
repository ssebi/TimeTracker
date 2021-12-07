
struct AddScreenUIComposer {

	private init() { }

	static func makeAddScreen(clientsLoader: ClientsLoader, timeslotsPublisher: TimeSlotsPublisher, userLoader: UserLoader) -> AddView {
		AddView(timeSlotVM:
					TimeSlotViewModel(clientsLoader: clientsLoader,
									  timeslotPublisher: timeslotsPublisher,
									  userLoader: userLoader))
	}

}
