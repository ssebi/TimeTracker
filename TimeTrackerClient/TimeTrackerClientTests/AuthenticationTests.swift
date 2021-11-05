//
//  AuthenticationTests.swift
//  TimeTrackerClientTests
//
//  Created by VSebastian on 05.11.2021.
//

import XCTest

protocol AuthProvider {
	func signIn()
	func signOut()
}

class SessionStoree {
	let authProvider: AuthProvider

	init(authProvider: AuthProvider) {
		self.authProvider = authProvider
	}

	func signIn() {
		authProvider.signIn()
	}

	func signOut() {
		authProvider.signOut()
	}
}

class AuthenticationTests: XCTestCase {

	func test_init_doesNotMessageAuthProvider() {
		let spy = AuthProviderSpy()
		let _ = SessionStoree(authProvider: spy)

		XCTAssertEqual(spy.signInCalls, 0)
	}

	func test_signIn_callsSignInOnAuthProvider() {
		let spy = AuthProviderSpy()
		let sut = SessionStoree(authProvider: spy)

		sut.signIn()

		XCTAssertEqual(spy.signInCalls, 1)
	}

	func test_signOut_callsSignOutOnAuthProvider() {
		let spy = AuthProviderSpy()
		let sut = SessionStoree(authProvider: spy)

		sut.signOut()

		XCTAssertEqual(spy.signOutCalls, 1)
	}

}

private class AuthProviderSpy: AuthProvider {
	var signInCalls = 0
	var signOutCalls = 0

	func signIn() {
		signInCalls += 1
	}

	func signOut() {
		signOutCalls += 1
	}
}
