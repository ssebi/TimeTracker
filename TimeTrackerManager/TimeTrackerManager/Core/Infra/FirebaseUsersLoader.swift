//
//  UserLoader.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 11.01.2022.
//

import Foundation
import Firebase
import TimeTrackerCore
import SwiftUI

class FirebaseUsersLoader  {

    init(store: TimeslotsStore){
        self.store = store
    }

    struct UndefinedError: Error { }
    typealias GetUsersResult = (Result<[User], Error>) -> Void
    typealias GetUserInfoResult = (Result<Void, Error>) -> Void
    typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void
    var store: TimeslotsStore

    func getUsers(completion: @escaping GetUsersResult) {
        var userTimeSlots = [Any]()
        Firestore.firestore().collection(Path.users).getDocuments() { (snapshot, error) in
            if let snapshot = snapshot {
                let user = snapshot.documents.compactMap { document -> User? in
                    let data = document.data()
                    let email = data["email"] as? String ?? ""
                    let firstName = data["firstName"] as? String ?? " "
                    let lastName = data["lastName"] as? String ?? ""
                    let userId = data["userId"] as? String ?? ""

                    return User(email: email, firstName: firstName, lastName: lastName, userId: userId, userDetails: [])
                }
                completion(.success((user)))
                user.forEach { userId in
                    self.getUserTimeslots(userId.userId) { result in
                        if case let .success(result) = result {
                            userTimeSlots.append(result)
                            print("success XX", userTimeSlots)
                        }
                        if case let .failure(error) = result {
                            print("ERROR", error)
                        }
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UndefinedError()))
            }
        }
    }

    public func getUserTimeslots(_ userId: String, completion: @escaping TimeslotsStore.GetTimeslotsResult) {
        store.getTimeslots(userID: userId) { result in
            switch result {
                case let .success(timeslots):
                    completion(.success(timeslots))

                case let .failure(error):
                    completion(.failure(error))
            }
        }
    }


}
