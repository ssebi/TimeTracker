//
//  ClientsLoaderSpy.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 11.11.2021.
//

import Foundation

protocol ClientsLoader {
    func getClients() -> [String]
}

class ClientsLoaderSpy: ClientsLoader {
    func getClients() -> [String] {
        return ["Client 1", "Client 2"]
    }
}
