
import XCTest
@testable import TimeTrackerClient

class FirebaseTimeslotsDataStoreEndToEndTests: XCTestCase {

	func test() {
		let sut = FirebaseTimeslotsStore()
		let validUserID = "YErySzP9KBgMsFw64rHrimFAUBZ2"

		let exp = expectation(description: "Wait for completion")
		var receivedTimeslots: [TimeSlot] = []
		sut.getTimeslots(userID: validUserID) { result in
			if let timeslots = try? result.get() {
				receivedTimeslots = timeslots
			}
			exp.fulfill()
		}
		wait(for: [exp], timeout: 5.0)

		XCTAssertEqual(receivedTimeslots.isEmpty, false)
	}

}
