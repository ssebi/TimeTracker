//
//  ClientsLoaderSpy.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 11.11.2021.
//

import Foundation
@testable import TimeTrackerClient

protocol ClientsLoader {
	typealias Result = (Swift.Result<[Client], Error>) -> Void

	func getClients(completion: @escaping Result)
}

class ClientsLoaderSpy: ClientsLoader {
	private(set) var getClientsCalls = 0

	private var clientsResult: ClientsLoader.Result?

	func getClients(completion: @escaping ClientsLoader.Result) {
		getClientsCalls += 1

		clientsResult = completion
	}

	func completeGetClientsWith(_ clients: [Client]) {
		clientsResult?(.success(clients))
	}
}
