//
//  FirebaseClientPublisher.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 26.01.2022.
//

import Foundation
import Firebase

class FirebaseClientPublisher {
    typealias ClientPublisherCompletion = (Result<Void, Error>) -> Void

    public func createClient(_ name: String, project: String, completion: @escaping ClientPublisherCompletion) {
        let data = [
            "name": name,
            "projects": [project]
        ] as [String: Any]

        Firestore.firestore().collection(Path.clients).document().setData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

}
