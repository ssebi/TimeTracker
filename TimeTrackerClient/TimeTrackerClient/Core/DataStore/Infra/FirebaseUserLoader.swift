
import Firebase

// TODO: - Might have to remove this along side the protocol
class FirebaseUserLoader: UserLoader {
	func getUser() -> User {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
           return User(uid: currentUser?.uid, email: currentUser?.email, username: currentUser?.displayName, client: "")
        } else {
           return User(uid: UUID().uuidString, email: nil, username: nil, client: nil)
        }
    }
}
