
import FirebaseAuth
import TimeTrackerAuth

class FirebaseUserLoader: UserLoader {
	func getUser() -> TimeTrackerAuth.User {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
           return User(uid: currentUser?.uid, email: currentUser?.email, username: currentUser?.displayName, client: "")
        } else {
           return User(uid: UUID().uuidString, email: nil, username: nil, client: nil)
        }
    }
}
