import TimeTrackerCore

struct HomeScreenUIComposer {

	static func makeHomeScreen(timeslotsLoader: TimeslotsLoader, userLoader: UserLoader, addView: @escaping () -> AddView) -> HomeView {
		HomeView(addView: addView, viewModel: HomeScreenViewModel(timeslotsLoader: timeslotsLoader, userLoader: userLoader))
	}

}
