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
            guard error != nil else {
                //do something on success
                completion(error)
                return
            }
            completion(error)
        }
    }
    
    //listen for live changes
    func listenForTimeSlot(from path: String, completion: @escaping (Result<QuerySnapshot, Error> ) -> Void) {
        Firestore.firestore().collection(path).getDocuments() { (querySnapshot, error) in
            guard error != nil else {
                for _ in querySnapshot!.documents {
                    //
                }
                completion(.success(querySnapshot!))
                return
            }
            completion(.failure(error!))
        }
    }
    
    func fetchData() {
        let docRef = Firestore.firestore().collection("userId").document("YErySzP9KBgMsFw64rHrimFAUBZ2/Client x/Project x/timelLoged/19-01-2021/timeslots/NPL3hZyBbxpq1jlQ2m81")
        docRef.getDocument { (document, error ) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    self.timeslot = data["time"] as? String ?? "No time logged xx"
                }
            }
        }
    }
    
    func fetchUsersTimeslots() {
        let path = "userId/YErySzP9KBgMsFw64rHrimFAUBZ2/Client x/Project x/timelLoged/02-11-2021/timeslots"
        Firestore.firestore().collection(path).addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                self.userTimeslots = querySnapshot.documents.compactMap { document in
                    do{
                        return try document.data(as: TimeSlot.self)
                    }
                    catch{
                        //log error
                    }
                    return nil
                }
            }
        }
    }
    
    func fetchAllData() {
        let db = Firestore.firestore()
        
        db.collection("userId").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID): \(document.data())")
                }
            }
        }
    }
    
    init(){
        fetchUsersTimeslots()
    }
    
}

