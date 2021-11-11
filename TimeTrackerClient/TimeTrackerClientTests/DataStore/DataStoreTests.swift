//
//  DataStoreTests.swift
//  TimeTrackerClientTests
//
//  Created by VSebastian on 11.11.2021.
//

import XCTest

class DataStore {
    let clientLoader: ClientsLoaderSpy
    let timeslotsLoader: TimeSlotsLoader

    init() {
        clientLoader = ClientsLoaderSpy()
        timeslotsLoader = TimeSlotsLoaderSpy(clients: clientLoader.getClients())
    }
}

class DataStoreTests: XCTestCase {

	func test_init() {
		let ds = DataStore()
		XCTAssertNotNil(ds)
	}

    func test_getClientNotNil() {
        let ( _, sut) = makeSut()
        let clients = sut.clientLoader.getClients()

        XCTAssertNotNil(clients)
    }

    //: Mark Helpers

    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (ClientsLoaderSpy, DataStore) {
        let spy = ClientsLoaderSpy()
        let sut = DataStore()
        addTeardownBlock { [weak spy, weak sut] in
            XCTAssertNil(spy, file: file, line: line)
            XCTAssertNil(sut, file: file, line: line)
        }
        return (spy, sut)
    }
}

