//
//  AuthProviderSpy.swift
//  TimeTrackerClientTests
//
//  Created by VSebastian on 10.11.2021.
//

import Foundation
@testable import TimeTrackerClient

class AuthProviderSpy: AuthProvider {
	struct NoUser: Error {}

	private(set) var checkAuthStateCalls = 0
	private(set) var signInCalls = 0
	private(set) var signOutCalls = 0
	private(set) var email = ""
	private(set) var password = ""

	private var signOutError: Error?
	private var authStateCheckResult: User?
	private(set) var authCompletion: SesionStoreResult?

	init(user: User?) {
		authStateCheckResult = user
	}

	func checkAuthState() -> User? {
		checkAuthStateCalls += 1
		return authStateCheckResult
	}

	func signIn(email: String, password: String, completion: @escaping SesionStoreResult) {
		signInCalls += 1
		self.email = email
		self.password = password
		self.authCompletion = completion
	}

	func signOut() throws {
		signOutCalls += 1
		if let err = signOutError {
			throw err
		}
	}

	func completeSignInWith(result: Result<TimeTrackerClient.User?, Error>) {
		authCompletion?(result)
	}

	func completeSignInWithNoUserFailure() {
		authCompletion?(.failure(NoUser()))
	}

	func completeSignOutWithFailure() {
		signOutError = NSError(domain: "test", code: 0)
	}

	func completeAuthStateCheckWithNoUser() {
		authStateCheckResult = nil
	}
}
