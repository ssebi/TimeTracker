//
//  SesionStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 13.10.2021.
//
import Firebase
import Combine

public class SessionStore: ObservableObject {
    // MARK: - Properties
    var didChange = PassthroughSubject<SessionStore, Never>()
    var session: User? {
        didSet {
            didChange.send(self)
        }
    }
    var handle: AuthStateDidChangeListenerHandle?
    public typealias SesionStoreResult = (Result<Bool, Error>) -> Void
    
    public struct NoUser: Error {}

    // MARK: - Functions
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(
                    uid: user.uid,
                    email: user.email,
                    username: user.displayName
                )
            } else {
                self.session = nil
            }
        }
    }
    
    public func singIn(email: String, password: String, completion: @escaping SesionStoreResult) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard result != nil else {
                completion(.failure(NoUser()))
                return
            }
            
            completion(.success(true))
        }
    }
    
    func singOut() -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
