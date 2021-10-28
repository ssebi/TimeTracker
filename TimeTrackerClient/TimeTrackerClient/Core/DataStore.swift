//
//  DataStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation
import Firebase


class DataStore {
    func addTimeSlot(with data: [String: Any], to path: String, completion: @escaping (Error?) -> Void) {
        Firestore.firestore().collection(path).document().setData(data) { error in
            guard error != nil else {
                //do something on success
                completion(error)
                return
            }
            completion(error)
        }
    }
    
    func getTimeSlot(from path: String, completion: @escaping (Result<QuerySnapshot, Error> ) -> Void) {
        Firestore.firestore().collection(path).getDocuments() { (querySnapshot, error) in
            guard error != nil else {
                for _ in querySnapshot!.documents {
                    // show document in interface
                }
                completion(.success(querySnapshot!))
                return
            }
            completion(.failure(error!))
        }
    }
}
