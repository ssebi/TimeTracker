
import FirebaseAuth
import FirebaseFirestore

public class FirebaseUserLoader: UserLoader, ManagerLoader{
    public init(){}

    struct UndefinedError: Error { }

    public func getUser() -> User {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            return User(uid: currentUser?.uid, email: currentUser?.email, username: currentUser?.displayName, client: "")
        } else {
            return User(uid: UUID().uuidString, email: nil, username: nil, client: nil)
        }
    }

    public func getManager(companyEmail: String) async throws -> Manager? {
        try await withCheckedThrowingContinuation { continuation in
            Firestore.firestore().collection(Path.managers)
                .whereField("email", isEqualTo: companyEmail)
                .getDocuments { snapshot, error in
                guard error == nil else {
                    continuation.resume(throwing: error!)
                    return
                }
                guard let snapshot = snapshot else {
                    continuation.resume(throwing: UndefinedError())
                    return
                }
                let manager = snapshot.documents.compactMap { document -> Manager? in
                    let data = document.data()
                    let id = document.documentID
                    guard let name = data["name"] as? String,
                            let email = data["email"] as? String else {
                              return nil
                          }
                    return Manager(id: id, email: email, name: name)
                }
                continuation.resume(returning: manager[0])
            }
        }
    }
}
