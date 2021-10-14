//
//  SesionStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 13.10.2021.
//
import Firebase

public class SessionStore {
    
    var authError: Error?
    var authResult: AuthDataResult?
    public typealias SesionStoreResult = (Result<Bool, Error>) -> Void
    
    public struct NoUser: Error {}
    
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
        do{
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
}
