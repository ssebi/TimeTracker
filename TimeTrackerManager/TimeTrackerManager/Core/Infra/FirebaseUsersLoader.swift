//
//  UserLoader.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 11.01.2022.
//

import Foundation
import Firebase
import TimeTrackerCore
import UIKit

class FirebaseUsersLoader {

    init(store: TimeslotsStore) {
        self.store = store
    }

    struct UndefinedError: Error { }
    typealias GetUsersResult = (Result<[UserCell], Error>) -> Void
    typealias GetUserInfoResult = (Result<Void, Error>) -> Void
    typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void
    var store: TimeslotsStore

    func getUsers(completion: @escaping GetUsersResult) {
        Firestore.firestore().collection(Path.users).getDocuments { (snapshot, error) in
			guard error == nil else {
				completion(.failure(error!))
				return
			}
			guard let snapshot = snapshot else {
				completion(.failure(UndefinedError()))
				return
			}
			let users = snapshot.documents.compactMap { [weak self] document -> UserCell? in
				let data = document.data()
				let documentId = document.documentID
				let userId = data["userId"] as? String ?? ""
				let name = "\(data["firstName"] ?? "") \(data["lastName"] ?? "")"
				let profilePicture = data["profilePicture"] as? String ?? ""
				let hourRate = data["hourRate"] as? String ?? "$100"

				return UserCell(name: name,
								userId: userId,
								profilePicture: profilePicture,
								documentId: documentId,
								hourRate: hourRate,
								timeSlots: self?.getUserTimeslots)
			}
			completion(.success((users)))
        }
    }

    private func getUserTimeslots(_ userId: String, completion: @escaping TimeslotsStore.GetTimeslotsResult) {
        store.getTimeslots(userID: userId) { result in
            switch result {
            case let .success(timeslots):
                completion(.success(timeslots))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func deleteUser(_ docId: String) {
        Firestore.firestore().collection("users").document(docId).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
