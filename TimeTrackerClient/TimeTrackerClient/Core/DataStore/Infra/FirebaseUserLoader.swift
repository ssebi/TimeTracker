
import Firebase

// TODO: - Might have to remove this along side the protocol
class FirebaseUserLoader: UserLoader {
	func getUser() -> User {
		// TODO: - Implement
		User(uid: UUID().uuidString, email: nil, username: nil, client: nil)
	}

}
