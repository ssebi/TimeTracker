
import XCTest
import TimeTrackerCore

class FirebaseTimeslotsDataStoreEndToEndTests: XCTestCase {

	func test() {
		let sut = FirebaseTimeslotsStore()
		let validUserID = "l7z4cGrBsNfwRHcWC9P9kqTOVtl1"

		let exp = expectation(description: "Wait for completion")
		var receivedError: Error? = nil
		sut.getTimeslots(userID: validUserID) { result in
			switch result {
				case let .failure(error):
					receivedError = error
				case .success:
					receivedError = nil
			}
			exp.fulfill()
		}
		wait(for: [exp], timeout: 5.0)

		XCTAssertNil(receivedError)
	}

}
