//
//  FirebaseAuthProvider.swift
//  TimeTrackerClient
//
//  Created by VSebastian on 10.11.2021.
//

import Firebase

class FirebaseAuthProvider: AuthProvider {
	struct NoUser: Error {}

	private var auth = Auth.auth()

	func checkAuthState() -> User? {
		Self.mapUser(auth.currentUser)
	}

	func signIn(email: String, password: String, completion: @escaping SesionStoreResult) {
		auth.signIn(withEmail: email, password: password) { (result, error) in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard result != nil else {
				completion(.failure(NoUser()))
				return
			}

			completion(.success(User(
				uid: result?.user.uid,
				email: result?.user.email,
				username: result?.user.displayName,
				client: "")))
		}
	}

	func signOut() throws {
		try auth.signOut()
	}

	private static func mapUser(_ user: Firebase.User?) -> TimeTrackerClient.User? {
		guard let user = user else {
			return nil
		}
		return TimeTrackerClient.User(uid: user.uid,
									  email: user.email,
									  username: user.displayName,
									  client: "")
	}
}
