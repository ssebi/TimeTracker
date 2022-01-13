
import FirebaseAuth

public class FirebaseUserLoader: UserLoader {
    public init(){}

    //TODO: Move user to CORE
    public func getUser() -> User {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            return User(uid: currentUser?.uid, email: currentUser?.email, username: currentUser?.displayName, client: "")
        } else {
            return User(uid: UUID().uuidString, email: nil, username: nil, client: nil)
        }
    }
}
