
import XCTest
@testable import TimeTrackerClient

class TimeslotsUIComposerTests: XCTestCase {

	func test_init_callsLoader() {
		let loader = TimeslotsLoaderSpy(store: MockStore())
		let _ = HomeScreenUIComposer.makeHomeScreen(timeslotsLoader: loader, userLoader: UserLoaderMock())

		XCTAssertEqual(loader.getTimeslotsCallCount, 1)
	}
	
}
