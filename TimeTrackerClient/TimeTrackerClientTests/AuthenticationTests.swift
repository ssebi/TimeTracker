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
	func signOut() throws
}

class SessionStoree {
    typealias SesionStoreResult = (Result<User, Error>) -> Void

	var user: User?
	let authProvider: AuthProvider

	init(authProvider: AuthProvider) {
		self.authProvider = authProvider
	}

    func signIn(email: String, password: String, completion: @escaping SesionStoreResult) {
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

	func test_signIn_failsWhenAuthProviderSignInFails() {
		let (spy, sut) = makeSut()

		expect(signInToCompleteWithFailureFor: sut, on: {
			spy.completeSignInWithNoUserFailure()
		})
	}

    func test_signIn_setsUserValue() {
        let (spy, sut) = makeSut()

		expect(signInToCompleteWithSuccessFor: sut, on: {
			spy.completeSignInWith(result: .success(someUser))
		})

		XCTAssertNotNil(sut.user)
		XCTAssertEqual(sut.user, someUser)
    }

	func test_signOut_failsWhenAuthProviderSignOutFails() {
		let (spy, sut) = makeSut()
		expect(signInToCompleteWithSuccessFor: sut, on: {
			spy.completeSignInWith(result: .success(someUser))
		})

		spy.completeSignOutWithFailure()
		let result = sut.signOut()

		XCTAssertEqual(result, false)
	}

    func test_signOut_setsUserValueAsNil() {
		let (spy, sut) = makeSut()
		expect(signInToCompleteWithSuccessFor: sut, on: {
			spy.completeSignInWith(result: .success(someUser))
		})

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

	private func expect(signInToCompleteWithSuccessFor sut: SessionStoree, on action: () -> Void) {
		let exp = expectation(description: "wait for signIn")
		sut.signIn(email: someEmail, password: somePassword) { result in
			if case .success = result {
				exp.fulfill()
			}
		}
		action()
		wait(for: [exp], timeout: 1.0)
	}

	private func expect(signInToCompleteWithFailureFor sut: SessionStoree, on action: () -> Void) {
		let exp = expectation(description: "wait for signIn")
		sut.signIn(email: someEmail, password: somePassword) { result in
			if case let.failure(err) = result {
				XCTAssertEqual(err as NSError, AuthProviderSpy.NoUser() as NSError)
				exp.fulfill()
			}
		}
		action()
		wait(for: [exp], timeout: 1.0)
	}

    private var someEmail = "test@test.com"
    private var somePassword = "pass123"
	private lazy var someUser = User(uid: UUID().uuidString, email: someEmail, username: somePassword, client: nil)

}

private class AuthProviderSpy: AuthProvider {
    typealias SesionStoreResult = (Result<User, Error>) -> Void

	struct NoUser: Error {}

	private(set) var signInCalls = 0
	private(set) var signOutCalls = 0
    private(set) var email = ""
    private(set) var password = ""

	private var signOutError: Error?
	var completion: SesionStoreResult?

    func signIn(email: String, password: String, completion: @escaping SesionStoreResult) {
		signInCalls += 1
        self.email = email
        self.password = password
		self.completion = completion
	}

	func signOut() throws {
		signOutCalls += 1
		if let err = signOutError {
			throw err
		}
	}

	func completeSignInWith(result: Result<User, Error>) {
		completion?(result)
	}

	func completeSignInWithNoUserFailure() {
		completion?(.failure(NoUser()))
	}

	func completeSignOutWithFailure() {
		signOutError = NSError(domain: "test", code: 0)
	}
}
