//
//  AuthenticationTests.swift
//  TimeTrackerClientTests
//
//  Created by VSebastian on 05.11.2021.
//

import XCTest
import TimeTrackerAuth

class AuthenticationTests: XCTestCase {

	func test_init_doesNotMessageAuthProvider() {
		let (spy, _) = makeSut()

		XCTAssertEqual(spy.signInCalls, 0)
	}

	func test_init_callsCheckAuthState() {
		let (spy, _) = makeSut()

		XCTAssertEqual(spy.checkAuthStateCalls, 1)
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

	func test_init_userIsNilWhenAuthStateCheckDeliversNil() {
		let (spy, sut) = makeSut()

		spy.completeAuthStateCheckWithNoUser()

		XCTAssertNil(sut.user)
	}

	func test_init_userHasValueWhenAuthStateCheckDeliversUser() {
		let (_, sut) = makeSut(user: someUser)

		XCTAssertNotNil(sut.user)
	}

	// MRK: - Helpers

	private func makeSut(user: User? = nil, file: StaticString = #filePath, line: UInt = #line) -> (AuthProviderSpy, SessionStore) {
		let spy = AuthProviderSpy(user: user)
		let sut = SessionStore(authProvider: spy)

		trackForMemoryLeaks(spy, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)

		return (spy, sut)
	}

	private func expect(signInToCompleteWithSuccessFor sut: SessionStore, on action: () -> Void) {
		let exp = expectation(description: "wait for signIn")
		sut.signIn(email: someEmail, password: somePassword) { result in
			if case .success = result {
				exp.fulfill()
			}
		}
		action()
		wait(for: [exp], timeout: 1.0)
	}

	private func expect(signInToCompleteWithFailureFor sut: SessionStore, on action: () -> Void) {
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
