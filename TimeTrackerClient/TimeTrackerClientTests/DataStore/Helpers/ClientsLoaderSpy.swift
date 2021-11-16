//
//  ClientsLoaderSpy.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 11.11.2021.
//

import Foundation
import TimeTrackerClient

class ClientsLoaderSpy: ClientsLoader {
	private(set) var getClientsCalls = 0

	private var clientsResult: ClientsLoader.Result?

	func getClients(completion: @escaping ClientsLoader.Result) {
		getClientsCalls += 1

		clientsResult = completion
	}

	func completeGetClients(with clients: [Client]) {
		clientsResult?(.success(clients))
	}

	func completeGetClients(with error: Error) {
		clientsResult?(.failure(error))
	}
}
