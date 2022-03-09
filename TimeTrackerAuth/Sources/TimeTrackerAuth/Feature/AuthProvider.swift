//
//  AuthProvider.swift
//  TimeTrackerClient
//
//  Created by VSebastian on 10.11.2021.
//
import TimeTrackerCore

public protocol AuthProvider {
	typealias SesionStoreResult = (Result<User?, Error>) -> Void
    typealias ForgotPasswordResult = (Result<Void, Error>) -> Void

	func checkAuthState() -> User?
	func signIn(email: String, password: String, completion: @escaping SesionStoreResult)
	func signOut() throws
    func forgotPassword(email: String, completion: @escaping ForgotPasswordResult)
    func createAccount(email: String, password: String, completion: @escaping SesionStoreResult)
}
