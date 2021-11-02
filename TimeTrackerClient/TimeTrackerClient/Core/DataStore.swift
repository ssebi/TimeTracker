//
//  DataStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation
import Firebase


class DataStore: ObservableObject {
    @Published var timeslot: String = ""
    @Published var userTimeslots = [TimeSlot]()
    
    func addTimeSlot(with data: [String: Any], to path: String, completion: @escaping (Error?) -> Void) {
        Firestore.firestore().collection(path).document().setData(data) { error in
            completion(error)
        }
    }
    
    func fetchUsersTimeslots() {
        let path = "userId/YErySzP9KBgMsFw64rHrimFAUBZ2/Client x/Project x/timelLoged/02-11-2021/timeslots"
        Firestore.firestore().collection(path).addSnapshotListener { [weak self]  (querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                self?.userTimeslots = querySnapshot.documents.compactMap { document in
                        return try? document.data(as: TimeSlot.self)
                }
            }
        }
    }
}

