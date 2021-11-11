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
        let ( _,_, sut) = makeSut()
        let clients = sut.clientLoader.getClients()

        XCTAssertNotNil(clients)
    }

    func test_getTimeSlotsNotNil() {
        let ( _, _, sut) = makeSut()
        let timeSlots = sut.timeslotsLoader.getTimeSlots()

        XCTAssertNotNil(timeSlots)
    }

    //: Mark Helpers

    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (ClientsLoaderSpy, TimeSlotsLoaderSpy, DataStore) {
        let cSpy = ClientsLoaderSpy()
        let tSpy = TimeSlotsLoaderSpy(clients: cSpy.getClients())
        let sut = DataStore()
        addTeardownBlock { [weak cSpy, weak tSpy, weak sut] in
            XCTAssertNil(cSpy, file: file, line: line)
            XCTAssertNil(tSpy, file: file, line: line)
            XCTAssertNil(sut, file: file, line: line)
        }
        return (cSpy, tSpy, sut)
    }
}

