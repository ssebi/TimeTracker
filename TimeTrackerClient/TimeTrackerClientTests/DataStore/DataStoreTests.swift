//
//  DataStoreTests.swift
//  TimeTrackerClientTests
//
//  Created by VSebastian on 11.11.2021.
//

import XCTest


class DataStore {
    let clientLoader: ClientsLoader
    let timeslotsLoader: TimeSlotsLoader

    init() {
        clientLoader = ClientsLoader()
        timeslotsLoader = TimeSlotsLoader(clients: clientLoader.getClients())
    }
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

    func test_getClientNotNil() {

    }

    //: Mark Helpers

    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (ClientsLoader, DataStore) {
        let spy = ClientsLoader()
        let sut = DataStore()
        addTeardownBlock { [weak spy, weak sut] in
            XCTAssertNil(spy, file: file, line: line)
            XCTAssertNil(sut, file: file, line: line)
        }
        return (spy, sut)
    }
}

