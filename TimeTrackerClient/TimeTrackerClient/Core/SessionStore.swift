//
//  SesionStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 13.10.2021.
//

import Combine
import SwiftUI

class SessionStore: ObservableObject {
	@Published var user: User?
	let authProvider: AuthProvider

	init(authProvider: AuthProvider) {
		self.authProvider = authProvider
		_ = self.authProvider.checkAuthState()
	}

	func signIn(email: String, password: String, completion: @escaping AuthProvider.SesionStoreResult) {
		authProvider.signIn(email: email, password: password) { [weak self] result in
			if case let .success(user) = result {
				self?.user = user
			}
			completion(result)
		}
	}

	@discardableResult
	func signOut() -> Bool {
		do {
			try authProvider.signOut()
			user = nil
			return true
		} catch {
			return false
		}
	}
}
