//
//  DataStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation
import Firebase


class DataStore {
    func addTimeSlot(with data: [String: Any], from path: String, completion: @escaping (Error?) -> Void) {
        Firestore.firestore().collection(path).addDocument(data: data) { error in
            guard error != nil else {
                //do something on success
                completion(error)
                return
            }
            completion(error)
        }
    }
    
    func getTimeSlot(from path: String, completion: @escaping (Result<QuerySnapshot, Error> ) -> Void) {
        Firestore.firestore().collection(path).getDocuments() { (qerySnapshot, error) in
            guard error != nil else {
                for _ in qerySnapshot!.documents {
                    // show document in interface
                }
                completion(.success(qerySnapshot!))
                return
            }
            completion(.failure(error!))
        }
    }
}
