//
//  FirebaseProjectsPublisher.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 31.01.2022.
//

import Foundation
import Firebase

class FirebaseProjectPublisher {
    typealias ProjectPublisherCompletion = (Result<Void, Error>) -> Void

    public func createProject(_ name: String, client: String, completion: @escaping ProjectPublisherCompletion) {
        let newProject = Firestore.firestore().collection(Path.clients).document(client)
        newProject.updateData([
            "projects": FieldValue.arrayUnion([name])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
