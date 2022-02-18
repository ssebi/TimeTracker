//
//  FirebaseClientPublisher.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 26.01.2022.
//

import Foundation
import Firebase
import TimeTrackerCore

final class FirebaseClientPublisher {
    typealias ClientPublisherCompletion = (Result<Void, Error>) -> Void

    public func createClient(_ name: String,
                             _ project: String,
                             _ address: String ,
                             _ vat: String,
                             _ country: String,
                             _ hourRate: Int,
                             completion: @escaping ClientPublisherCompletion) {
        let data = [
            "name": name,
            "projects": [project],
            "address": address,
            "vat": vat,
            "country": country,
            "hourRate": hourRate
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
