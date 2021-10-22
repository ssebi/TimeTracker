//
//  DataStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation
import Firebase


class DataStore {
 
    var err: Error?
    var ref: DocumentReference? = nil
    
    func addTimeSlot(with data: [String: Any], from path: String) {
        ref = Firestore.firestore().collection(path).addDocument(data: data) { error in
            self.err = error
            
            if self.err == nil {
                print("Document added with ID: \(self.ref!.documentID)")
            } else {
                print("There was an error addidng the document")
            }
        }
    }
    
    func getTimeSlot(from path: String){
        Firestore.firestore().collection(path).getDocuments() { (qerySnapshot, error) in
            self.err = error
            if self.err != nil {
                print("Error getting documents:\(self.err!)")
            } else {
                for document in qerySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    
}
