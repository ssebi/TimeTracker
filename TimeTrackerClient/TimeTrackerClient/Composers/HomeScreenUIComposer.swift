
struct HomeScreenUIComposer {

	static func makeHomeScreen(timeslotsLoader: TimeslotsLoader, userLoader: UserLoader) -> HomeView {
		HomeView(viewModel: HomeScreenViewModel(timeslotsLoader: timeslotsLoader, userLoader: userLoader))
	}

}
