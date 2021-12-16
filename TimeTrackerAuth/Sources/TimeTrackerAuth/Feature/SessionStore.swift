//
//  SesionStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 13.10.2021.
//

import Combine

public class SessionStore: ObservableObject {
	@Published public private(set) var user: User?
	private let authProvider: AuthProvider

	public init(authProvider: AuthProvider) {
		self.authProvider = authProvider
		user = self.authProvider.checkAuthState()
	}

	public func signIn(email: String, password: String, completion: @escaping AuthProvider.SesionStoreResult) {
		authProvider.signIn(email: email, password: password) { [weak self] result in
			if case let .success(user) = result {
				self?.user = user
			}
			completion(result)
		}
	}

	@discardableResult
	public func signOut() -> Bool {
		do {
			try authProvider.signOut()
			user = nil
			return true
		} catch {
			return false
		}
	}
}
