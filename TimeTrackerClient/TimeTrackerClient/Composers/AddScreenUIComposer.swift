
struct AddScreenUIComposer {

	private init() { }

	static func makeAddScreen() -> AddView {
		AddView(timeSlotVM:
					TimeSlotViewModel(clientsLoader: RemoteClientsLoader(store: FirebaseClientsStore()),
									  timeslotPublisher: RemoteTimeSlotsPublisher(store: FirebaseTimeslotsStore()),
									  userLoader: FirebaseUserLoader()))
	}

}
