//
//  UserLoader.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 11.01.2022.
//

import Foundation
import Firebase
import TimeTrackerCore

class FirebaseUsersLoader  {

    init(store: TimeslotsStore){
        self.store = store
    }

    struct UndefinedError: Error { }
    typealias GetUsersResult = (Result<[UserCell], Error>) -> Void
    typealias GetUserInfoResult = (Result<Void, Error>) -> Void
    typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void
    var store: TimeslotsStore


    func getUsers(completion: @escaping GetUsersResult) {
        Firestore.firestore().collection(Path.users).getDocuments() { (snapshot, error) in
            if let snapshot = snapshot {
                let users = snapshot.documents.compactMap { document -> UserCell? in
                    let data = document.data()
                    let userId = data["userId"] as? String ?? ""
                    var totalHours = 0
                    var allProjects = Set<String>()

                   self.getUserTimeslots(userId) { result in
                        if case let .success(result) = result {
                            result.forEach { timeSlot in
                                totalHours += timeSlot.total
                                allProjects.insert(timeSlot.projectName)
                            }
                        }
                        if case let .failure(error) = result {
                            print("ERROR", error)
                        }
                    }
                    let projects = "\(allProjects)"
                    let name = "\(data["firstName"] ?? "") \(data["lastName"] ?? "")"
                    let profilePicture = data["profilePicture"] as? String ?? ""
                    let hourRate = data["hourRate"] as? String ?? "$100"

                    return UserCell(name: name, userId: userId, profilePicture: profilePicture, totalHours: totalHours, projects: projects, hourRate: hourRate)
                }
                completion(.success((users)))
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

    public func deleteUser(_ userId: String) {
        Firestore.firestore().collection("users").document(userId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }


}
