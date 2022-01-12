//
//  UserLoader.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 11.01.2022.
//

import Foundation
import Firebase

class FirebaseUserLoader: UserLoader  {

    func getUsers(completion: @escaping GetUsersResult) {
        //        Firestore.firestore().collection("users").getDocuments() { (querySnapshot, err) in
        //            if let err = err {
        //                print("Error getting documents: \(err)")
        //            } else {
        //                for document in querySnapshot!.documents {
        //                    print("\(document.documentID) => \(document.data())")
        //                }
        //            }
        //        }

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

//    func getUserTimeSlots(userId: String, completion: @escaping GetUserInfoResult) {
//        Firestore.firestore().collection(Path.timeSlots)
//            .whereField("userId", isEqualTo: userId)
//            .getDocuments { (querySnapshot, error) in
//                if let querySnapshot = querySnapshot {
//                    let timeslots = querySnapshot.documents.compactMap { document -> FirebaseTimeSlot? in
//                        let decoder = JSONDecoder()
//                        decoder.dateDecodingStrategy = .iso8601
//                        if let data = try? JSONSerialization.data(withJSONObject: document.data()) {
//                            return try? decoder.decode(FirebaseTimeSlot.self, from: data)
//                        } else {
//                            return nil
//                        }
//                    }
//                    completion(.success(timeslots.toTimeSlot()))
//                } else {
//                    completion(.failure(error!))
//                }
//            }
//    }
}
