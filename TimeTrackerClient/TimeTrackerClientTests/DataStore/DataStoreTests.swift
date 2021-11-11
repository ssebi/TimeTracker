//
//  DataStoreTests.swift
//  TimeTrackerClientTests
//
//  Created by VSebastian on 11.11.2021.
//

import XCTest


class DataStore {

}

class ClientsLoader {
    func getClients() -> [String] {
        return ["Client 1", "Client 2"]
    }
}

class TimeSlotsLoader {
    let clients: [String]

    init(clients: [String]) {
        self.clients = clients
    }
}

class DataStoreTests: XCTestCase {

	func test_init() {
		let ds = DataStore()
		XCTAssertNotNil(ds)
	}



}
