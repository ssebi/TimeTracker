//
//  FirebaseAuthProvider.swift
//  TimeTrackerClient
//
//  Created by VSebastian on 10.11.2021.
//

import FirebaseAuth
import TimeTrackerCore
import Firebase

public class FirebaseAuthProvider: AuthProvider {
	struct NoUser: Error {}
    typealias UserPublisherCompletion = (Result<Void, UserPublisherError>) -> Void
    
    enum UserPublisherError: Error {
        case passwordResetFailed
        case userCreationFailed
        case addUserFailed
    }

	private var auth = Auth.auth()

	public init() { }

    public func checkAuthState() -> TimeTrackerCore.User? {
		Self.mapUser(auth.currentUser)
	}

	public func signIn(email: String, password: String, completion: @escaping SesionStoreResult) {
		auth.signIn(withEmail: email, password: password) { (result, error) in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard result != nil else {
				completion(.failure(NoUser()))
				return
			}

			completion(.success(Self.mapUser(result?.user)))
		}
	}

	public func signOut() throws {
		try auth.signOut()
	}

    private static func mapUser(_ user: FirebaseAuth.User?) -> TimeTrackerCore.User? {
		guard let user = user else {
			return nil
		}
		return User(uid: user.uid,
					email: user.email,
					username: user.displayName,
					client: "")
	}

    public func forgotPassword(email: String, completion: @escaping ForgotPasswordResult) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }

    public func createAccount(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        hourRate: String,
        manager: Manager,
        completion: @escaping SesionStoreResult) {
        auth.createUser(withEmail: email, password: password) { [weak self] (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard result != nil else {
                completion(.failure(NoUser()))
                return
            }
            guard let user = result?.user else { return }
            self?.createLocalUser(user, firstName: firstName, lastName: lastName, hourRate: hourRate, manager: manager) {_ in}
            completion(.success(Self.mapUser(user)))
        }
    }

    private func createLocalUser(
        _ user: Firebase.User,
        firstName: String,
        lastName: String,
        hourRate: String,
        manager: Manager,
        completion: @escaping UserPublisherCompletion) {
        let data = [
            "userId": user.uid,
            "firstName": firstName,
            "lastName": lastName,
            "hourRate": "$ \(hourRate)",
            "manager" : [
                "email": manager.email,
                "id": manager.id,
                "name": manager.name
            ],
            "profilePicture": "https://avatars.dicebear.com/api/bottts/:\(firstName).png"
        ] as [String: Any]

        Firestore.firestore().collection("users").document().setData(data) { error in
            if error != nil {
                completion(.failure(.userCreationFailed))
            } else {
                completion(.success(()))
            }
        }
    }
}
