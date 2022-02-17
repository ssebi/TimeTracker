//
//  FirebaseClientsLoader.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 26.01.2022.
//

import Foundation
import TimeTrackerCore
import Firebase

final class FirebaseClientsLoader {

    private let store: ClientsStore
    typealias GetClientsResult = (Result<[Client], Error>) -> Void
    typealias GetInvoiceTotalResult = (Result<[InvoiceTotal], Error>) -> Void

    func getClients(completion: @escaping GetClientsResult) {
        store.getClients { result in
            if case .success = result {
                completion(result)
            }
        }
    }

    init(store: ClientsStore) {
        self.store = store
    }
}
