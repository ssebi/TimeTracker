//
//  SesionStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 13.10.2021.
//
import Firebase
import Combine

class SessionStore: ObservableObject {
    // MARK: - Properties
    private(set) var didChange = PassthroughSubject<SessionStore, Never>()
    private(set) var session: User? {
        didSet {
            didChange.send(self)
        }
    }
    private var handle: AuthStateDidChangeListenerHandle?

    typealias SesionStoreResult = (Result<User, Error>) -> Void
    struct NoUser: Error {}

    // MARK: - Init
    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if let user = user {
                self?.session = User(
                    uid: user.uid,
                    email: user.email,
                    username: user.displayName
                )
            } else {
                self?.session = nil
            }
        }
    }

    // MARK: - Functions
    func singIn(email: String, password: String, completion: @escaping SesionStoreResult) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard result != nil else {
                completion(.failure(NoUser()))
                return
            }

            completion(.success(User(
                uid: result?.user.uid,
                email: result?.user.email,
                username: result?.user.displayName)))
        }
    }
    
    func singOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    
    private func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
