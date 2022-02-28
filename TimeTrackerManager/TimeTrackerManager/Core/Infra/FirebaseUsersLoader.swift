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

final class FirebaseUsersLoader {

    init(store: TimeslotsStore) {
        self.store = store
    }

    struct UndefinedError: Error { }
    typealias GetUsersResult = (Result<[UserCell], Error>) -> Void
    typealias GetUserInfoResult = (Result<Void, Error>) -> Void
    typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void
    var store: TimeslotsStore

    func getUsers() async throws -> [UserCell] {
		guard let partialUsers = try? await getPartialUsers() else {
			throw UndefinedError()
		}
		var usersWithTimeslots: [UserCell] = []
		for user in partialUsers {
			if let timeslots = await store.getTimeslots(userID: user.userId) {
				usersWithTimeslots.append(user.addTimeslots(timeslots))
			}
		}
		return usersWithTimeslots
	}

	private func getPartialUsers() async throws -> [UserCell] {
		try await withCheckedThrowingContinuation { continuation in
			Firestore.firestore().collection("users").getDocuments { snapshot, error in
				guard error == nil else {
					continuation.resume(throwing: error!)
					return
				}
				guard let snapshot = snapshot else {
					continuation.resume(throwing: UndefinedError())
					return
				}

				let users = snapshot.documents.compactMap { document -> UserCell? in
					let data = document.data()
					let documentId = document.documentID
					let userId = data["userId"] as? String ?? ""
					let name = "\(data["firstName"] ?? "") \(data["lastName"] ?? "")"
					let profilePicture = data["profilePicture"] as? String ?? ""
					let hourRate = data["hourRate"] as? String ?? ""

					return UserCell(name: name,
									userId: userId,
									profilePicture: profilePicture,
									documentId: documentId,
									hourRate: hourRate)
				}

				continuation.resume(returning: users)
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
