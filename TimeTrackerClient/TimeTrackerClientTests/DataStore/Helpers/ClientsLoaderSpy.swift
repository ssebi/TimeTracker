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
	private(set) var getClientsCalls = 0

	private var clients: [String] = []

    func getClients() -> [String] {
		getClientsCalls += 1
		return clients
    }

	func completeGetClientsWith(_ clients: [String]) {
		self.clients = clients
	}
}
