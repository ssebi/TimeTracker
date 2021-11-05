//
//  AuthenticationTests.swift
//  TimeTrackerClientTests
//
//  Created by VSebastian on 05.11.2021.
//

import XCTest

protocol AuthProvider {
	func signIn()
}

class SessionStoree {
	let authProvider: AuthProvider

	init(authProvider: AuthProvider) {
		self.authProvider = authProvider
	}
}

class AuthenticationTests: XCTestCase {


	func test_init_doesNotMessageAuthProvider() {
		let spy = AuthProviderSpy()
		let _ = SessionStoree(authProvider: spy)

		XCTAssertEqual(spy.signInCalls, 0)
	}


}

private class AuthProviderSpy: AuthProvider {
	var signInCalls = 0

	func signIn() {
		signInCalls += 1
	}
}
