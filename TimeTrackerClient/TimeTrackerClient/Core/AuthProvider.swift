//
//  AuthProvider.swift
//  TimeTrackerClient
//
//  Created by VSebastian on 10.11.2021.
//

protocol AuthProvider {
	typealias SesionStoreResult = (Result<User, Error>) -> Void

	func checkAuthState() -> User?
	func signIn(email: String, password: String, completion: @escaping SesionStoreResult)
	func signOut() throws
}
