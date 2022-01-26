//
//  FirebaseClientsLoader.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 26.01.2022.
//

import Foundation
import TimeTrackerCore
import Firebase

class FirebaseClientsLoader {

    var store: ClientsStore
    var client = [Client]()
    typealias GetClientsResult = (Result<[Client], Error>) -> Void

    func getClients(completion: @escaping GetClientsResult) {
        store.getClients(){ result in
            if case .success(_) = result {
                completion(result)
            }
        }
    }

    init(store: ClientsStore){
        self.store = store
    }
}
