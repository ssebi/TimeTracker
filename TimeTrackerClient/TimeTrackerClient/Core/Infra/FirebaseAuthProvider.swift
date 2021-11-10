//
//  FirebaseAuthProvider.swift
//  TimeTrackerClient
//
//  Created by VSebastian on 10.11.2021.
//

import Firebase

class FirebaseAuthProvider: AuthProvider {
	struct NoUser: Error {}

	func checkAuthState(completion: @escaping SesionStoreResult) {
		
	}

	func signIn(email: String, password: String, completion: @escaping SesionStoreResult) {
		Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
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
		try Auth.auth().signOut()
	}
}
