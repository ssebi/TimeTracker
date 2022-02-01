import Foundation
import Firebase
import TimeTrackerCore

final class FirebaseUserPublisher {
    typealias UserPublisherCompletion = (Result<Void, UserPublisherError>) -> Void

    enum UserPublisherError: Error {
        case passwordResetFailed
        case userCreationFailed
        case addUserFailed
    }

    public func addUser(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        completion: @escaping UserPublisherCompletion) {

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                completion(.failure(.addUserFailed))
            }
            if let result = authResult {
                self?.createUser(result.user, firstName: firstName, lastName: lastName) { result in
                    switch result {
                    case .success:
                        self?.resetPass(email: email, completion: { _ in
                            completion(.success(()))
                            // todo: do something on err
                        })

                    case .failure(let error):
                        completion(.failure(error))
                        // todo: delete created user
                    }
                }
            }
        }
    }

    private func createUser(
        _ user: Firebase.User,
        firstName: String,
        lastName: String,
        completion: @escaping UserPublisherCompletion) {
        let data = [
            "userId": user.uid,
            "firstName": firstName,
            "lastName": lastName,
            "profilePicture": "https://avatars.dicebear.com/api/bottts/:\(firstName).png"
        ]

        Firestore.firestore().collection("users").document().setData(data) { error in
            if error != nil {
                completion(.failure(.userCreationFailed))
            } else {
                completion(.success(()))
            }
        }
    }

    private func resetPass(email: String, completion: @escaping UserPublisherCompletion) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                completion(.failure(.passwordResetFailed))
            } else {
                completion(.success(()))
            }
        }
    }
}
