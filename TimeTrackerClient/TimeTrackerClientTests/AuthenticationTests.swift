//
//  AuthenticationTests.swift
//  TimeTrackerClientTests
//
//  Created by VSebastian on 05.11.2021.
//

import XCTest

protocol AuthProvider {
    var email: String { get }
    var password: String { get }
    func signIn(email: String, password: String)
	func signOut()
}

class SessionStoree {
	let authProvider: AuthProvider

	init(authProvider: AuthProvider) {
		self.authProvider = authProvider
	}

    func signIn(email: String, password: String) {
		authProvider.signIn(email: email, password: password)
	}

	func signOut() {
		authProvider.signOut()
	}
}

class AuthenticationTests: XCTestCase {

	func test_init_doesNotMessageAuthProvider() {
		let (spy, _) = makeSut()

		XCTAssertEqual(spy.signInCalls, 0)
	}

	func test_signIn_callsSignInOnAuthProvider() {
		let (spy, sut) = makeSut()
        let email = "mihai24vic@gmail.com"
        let password = "Patratel1"

		sut.signIn(email: email, password: password)

		XCTAssertEqual(spy.signInCalls, 1)
	}

    func test_signIn_hasValidCredentials() {
        let (spy, sut) = makeSut()

        sut.signIn(email: email, password: password)

        XCTAssertEqual(email, spy.email)
        XCTAssertEqual(password, spy.password)
    }

	func test_signOut_callsSignOutOnAuthProvider() {
		let (spy, sut) = makeSut()

		sut.signOut()

		XCTAssertEqual(spy.signOutCalls, 1)
	}

	// MRK: - Helpers

	private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (AuthProviderSpy, SessionStoree) {
		let spy = AuthProviderSpy()
		let sut = SessionStoree(authProvider: spy)
		addTeardownBlock { [weak spy, weak sut] in
			XCTAssertNil(spy, file: file, line: line)
			XCTAssertNil(sut, file: file, line: line)
		}
		return (spy, sut)
	}

    private var email = "test@test.com"
    private var password = "pass123"

}

private class AuthProviderSpy: AuthProvider {
	var signInCalls = 0
	var signOutCalls = 0
    var email = ""
    var password = ""

    func signIn(email: String, password: String) {
        self.email = email
        self.password = password
		signInCalls += 1
	}

	func signOut() {
		signOutCalls += 1
	}
}
