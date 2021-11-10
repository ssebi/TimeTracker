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
	let authProvider: AuthProvider
	init(authProvider: AuthProvider) {
		self.authProvider = authProvider
	}

    func signIn(email: String, password: String, completion: @escaping SesionStoreResult) {
        authProvider.signIn(email: email, password: password) { result in
            completion(.success(User(uid: "id", email: email, username: email, client: "")))
        }
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

        sut.signIn(email: email, password: password) { _ in }

		XCTAssertEqual(spy.signInCalls, 1)
	}

    func test_signIn_hasValidCredentials() {
        let (spy, sut) = makeSut()

        sut.signIn(email: email, password: password) { _ in }

        XCTAssertEqual(email, spy.email)
        XCTAssertEqual(password, spy.password)
    }

	func test_signOut_callsSignOutOnAuthProvider() {
		let (spy, sut) = makeSut()

		sut.signOut()

		XCTAssertEqual(spy.signOutCalls, 1)
	}

    func test_signIn_completionHandlerHasValue() {
        let (_, sut) = makeSut()
        sut.signIn(email: email, password: password) { result in
            XCTAssertNotNil(result)
        }
    }

    func test_signIn_sessionHasUser() {
        let (_, sut) = makeSut()

        sut.signIn(email: email, password: password) { result in
            if case let .success(user) = result {
                XCTAssertNotNil(user.email)
            } else {
                XCTFail()
            }
        }
    }

    func test_signOut_sessionNoUser() {
        let (spy, sut) = makeSut()

        sut.signIn(email: email, password: password) { _ in }
        XCTAssertNotNil(spy.user.email)
        sut.signOut()
        XCTAssertNil(spy.user.email)
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
    typealias SesionStoreResult = (Result<User, Error>) -> Void
    struct NoUser: Error {}
	var signInCalls = 0
	var signOutCalls = 0
    var email = "test@tes.com"
    var password = "password"
    var user = User(uid: "uid", email:" test@tes.com", username: "test", client: "")

    func signIn(email: String, password: String, completion: @escaping SesionStoreResult) {
        self.email = email
        self.password = password
		signInCalls += 1
        completion(.success(User(
            uid: user.email,
            email: user.email,
            username: user.username,
            client: user.client
        )))
	}

	func signOut() {
		signOutCalls += 1
        user = User(uid: nil, email: nil, username: nil, client: nil)
	}
}
