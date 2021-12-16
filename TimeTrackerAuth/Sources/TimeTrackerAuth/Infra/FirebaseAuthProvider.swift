//
//  FirebaseAuthProvider.swift
//  TimeTrackerClient
//
//  Created by VSebastian on 10.11.2021.
//

import FirebaseAuth

public class FirebaseAuthProvider: AuthProvider {
	struct NoUser: Error {}

	private var auth = Auth.auth()

	public init() { }

	public func checkAuthState() -> User? {
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

	private static func mapUser(_ user: FirebaseAuth.User?) -> User? {
		guard let user = user else {
			return nil
		}
		return User(uid: user.uid,
					email: user.email,
					username: user.displayName,
					client: "")
	}
}
