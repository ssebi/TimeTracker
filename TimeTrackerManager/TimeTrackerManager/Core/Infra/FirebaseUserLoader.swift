//
//  UserLoader.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 11.01.2022.
//

import Foundation
import Firebase

class FirebaseUserLoader  {
    struct UndefinedError: Error { }
    typealias GetUsersResult = (Result<[User], Error>) -> Void
    typealias GetUserInfoResult = (Result<Void, Error>) -> Void

    func getUsers(completion: @escaping GetUsersResult) {
        Firestore.firestore().collection(Path.users).getDocuments() { (snapshot, error) in
            if let snapshot = snapshot {
                let user = snapshot.documents.compactMap { document -> User? in
                    let data = document.data()
                    let email = data["email"] as? String ?? ""
                    let firstName = data["firstName"] as? String ?? " "
                    let lastName = data["lastName"] as? String ?? ""
                    let userId = data["userId"] as? String ?? ""
                    return User(email: email, firstName: firstName, lastName: lastName, userId: userId)
                }
                completion(.success((user)))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UndefinedError()))
            }
        }
    }
}
