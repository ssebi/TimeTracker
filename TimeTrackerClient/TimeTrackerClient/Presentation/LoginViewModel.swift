//
//  LoginViewModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 24.11.2021.
//

import Combine
import TimeTrackerAuth
import TimeTrackerCore

public class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var hourRate: String = ""
    @Published var companyEmail: String = ""
    @Published var showError = true
    @Published var toggle = true
    @Published var isForgotten = false
    @Published var isSignUp = false
    @Published var errrorMessage = ""
    @Published var isLoading = true
    @Published var manager = [Manager]()

    var session: SessionStore
    var userLoader: UserLoader

    typealias ForgotPasswordResult = (Result<Void, Error>) -> Void
    typealias CheckCompanyResult = (Result<Manager, Error>) -> Void

    init(session: SessionStore, userLoader: UserLoader){
        self.session = session
        self.userLoader = userLoader
        isLoading = false
    }

    func signIn() {
        isLoading = true
        session.signIn(email: username, password: password) { [weak self] result in
            self?.isLoading = false
            if case let .failure(result) =  result {
                self?.errrorMessage = result.localizedDescription
            }
        }
    }

    func forgotPassword(completion: @escaping ForgotPasswordResult) {
        isLoading = true
        session.forgotPassword(email: username) { [weak self] result in
            self?.isLoading = false
            if case let .failure(result) = result {
                self?.errrorMessage = result.localizedDescription
            }
            if case .success(_) = result {
                completion(.success(()))
            }
        }
    }

    func createAccount() {
        isLoading = true
        session.createAccount(email: username,
                              password: password,
                              firstName: firstName,
                              lastName: lastName,
                              hourRate: hourRate,
                              manager: manager[0]) { [weak self] result in
            self?.isLoading = false
            if case let .failure(result) =  result {
                self?.errrorMessage = result.localizedDescription
            }
        }
    }

    func checkCompany(completion: @escaping CheckCompanyResult) {
        isLoading = true
        userLoader.getManager(companyEmail: companyEmail) { [weak self] result in
            self?.isLoading = false
            if case let .failure(error) =  result {
                self?.errrorMessage = error.localizedDescription
            }
            if case let .success(manager) = result {
                guard manager.isEmpty else {
                    self?.manager = manager
                    return completion(.success(manager[0]))
                }
                self?.errrorMessage = "No match found"
            }
        }
    }
}
