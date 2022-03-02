//
//  LoginViewModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 24.11.2021.
//

import Combine
import TimeTrackerAuth

public class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showError = true
    @Published var toggle = true
    @Published var isForgotten = false
    @Published var signUp = false

    @Published var errrorMessage = ""

    @Published var isLoading = true
    var session: SessionStore
    typealias ForgotPasswordResult = (Result<Void, Error>) -> Void

    init(session: SessionStore){
        self.session = session
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
}
