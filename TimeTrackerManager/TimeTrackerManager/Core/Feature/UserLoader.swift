//
//  UserLoader.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 11.01.2022.
//

import Foundation
import Firebase

class UserLoader {
    struct UndefinedError: Error { }
    typealias GetUsersResult = (Result<[User], Error>) -> Void

        func getUsers(completion: @escaping GetUsersResult) {
            Firestore.firestore().collection(Path.users).getDocuments { snapshot, error in
                if let snapshot = snapshot {
                    let user = snapshot.documents.compactMap { document -> User? in
                        let data = document.data()
                        let email = data["email"] as? String ?? ""
                        let firstName = data["firstName"] as? String ?? " "
                        let lastName = data["lastName"] as? String ?? ""
                        return User(email: email, firstName: firstName, lastName: lastName)
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
