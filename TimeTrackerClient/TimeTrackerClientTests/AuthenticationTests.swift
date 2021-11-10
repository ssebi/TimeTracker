//
//  AuthenticationTests.swift
//  TimeTrackerClientTests
//
//  Created by VSebastian on 05.11.2021.
//

import XCTest

protocol AuthProvider {
    typealias SesionStoreResult = (Result<User, Error>) -> Void

    func signIn(email: String, password: String, completion: @escaping SesionStoreResult)
	func signOut()
}

class SessionStoree {
    typealias SesionStoreResult = (Result<User, Error>) -> Void
	var user: User?
	let authProvider: AuthProvider
	init(authProvider: AuthProvider) {
		self.authProvider = authProvider
	}

    func signIn(email: String, password: String, completion: @escaping SesionStoreResult) {
		authProvider.signIn(email: email, password: password) { result in
			if case let .success(user) = result {
				self.user = user
			}
		}
	}

	func signOut() {
		authProvider.signOut()
		user = nil
	}
}

class AuthenticationTests: XCTestCase {

	func test_init_doesNotMessageAuthProvider() {
		let (spy, _) = makeSut()

		XCTAssertEqual(spy.signInCalls, 0)
	}

	func test_signIn_callsSignInOnAuthProvider() {
		let (spy, sut) = makeSut()

        sut.signIn(email: someEmail, password: somePassword) { _ in }

		XCTAssertEqual(spy.signInCalls, 1)
	}

    func test_signIn_hasValidCredentials() {
        let (spy, sut) = makeSut()

        sut.signIn(email: someEmail, password: somePassword) { _ in }

        XCTAssertEqual(someEmail, spy.email)
        XCTAssertEqual(somePassword, spy.password)
    }

	func test_signOut_callsSignOutOnAuthProvider() {
		let (spy, sut) = makeSut()

		sut.signOut()

		XCTAssertEqual(spy.signOutCalls, 1)
	}

    func test_signIn_completionHandlerHasValue() {
        let (_, sut) = makeSut()
        sut.signIn(email: someEmail, password: somePassword) { result in
            XCTAssertNotNil(result)
        }
    }

    func test_signIn_setsUserValue() {
        let (spy, sut) = makeSut()

		spy.completeSignInWithSuccess()
        sut.signIn(email: someEmail, password: somePassword) { _ in }

		XCTAssertNotNil(sut.user)
    }

    func test_signOut_setsUserValueAsNil() {
        let (spy, sut) = makeSut()
		spy.completeSignInWithSuccess()
        sut.signIn(email: someEmail, password: somePassword) { _ in }

		sut.signOut()

		XCTAssertNil(sut.user)
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

    private var someEmail = "test@test.com"
    private var somePassword = "pass123"

}

private class AuthProviderSpy: AuthProvider {
    typealias SesionStoreResult = (Result<User, Error>) -> Void
    struct NoUser: Error {}
	private(set) var signInCalls = 0
	private(set) var signOutCalls = 0
    private(set) var email = "test@tes.com"
    private(set) var password = "password"
    var user = User(uid: "uid", email:" test@tes.com", username: "test", client: "")
	private var signInResult: Result<User, Error>?

    func signIn(email: String, password: String, completion: @escaping SesionStoreResult) {
        self.email = email
        self.password = password
		signInCalls += 1
		if let signInResult = signInResult {
			completion(signInResult)
		}
	}

	func signOut() {
		signOutCalls += 1
	}

	func completeSignInWithSuccess() {
		signInResult = .success(user)
	}
}
