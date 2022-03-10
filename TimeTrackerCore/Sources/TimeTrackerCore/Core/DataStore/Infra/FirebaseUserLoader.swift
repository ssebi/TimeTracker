
import FirebaseAuth
import FirebaseFirestore

public class FirebaseUserLoader: UserLoader {
    public init(){}

    public func getUser() -> User {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            return User(uid: currentUser?.uid, email: currentUser?.email, username: currentUser?.displayName, client: "")
        } else {
            return User(uid: UUID().uuidString, email: nil, username: nil, client: nil)
        }
    }

    public func getManager(companyEmail: String, completion: @escaping GetManagerResult) {
        Firestore.firestore().collection(Path.managers)
            .whereField("email", isEqualTo: companyEmail)
            .getDocuments { snapshot, error in
                if let snapshot = snapshot {
                    let manager = snapshot.documents.compactMap { document -> Manager? in
                        let data = document.data()
                        let id = document.documentID
                        guard let name = data["name"] as? String,
                                let email = data["email"] as? String else {
                                  return nil
                              }
                        return Manager(id: id, email: email, name: name)
                    }
                    completion(.success(manager))
                } else {
                    completion(.failure(error!))
                }
            }
    }
}
