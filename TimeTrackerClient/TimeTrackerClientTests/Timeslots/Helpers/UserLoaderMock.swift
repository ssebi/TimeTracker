
import Foundation
import TimeTrackerClient

class UserLoaderMock: UserLoader {

	func getUser() -> User {
		User(uid: UUID().uuidString, email: "somteEmail@test.com", username: "Test", client: "Client")
	}

}
