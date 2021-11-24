
import XCTest
import TimeTrackerClient

class TimeslotsAPIUseCaseTests: XCTestCase {

	func test_init_doesNotMessageStore() {
		let (store, _) = makeSUT()

		XCTAssertEqual(store.getTimeslotsCallCount, 0)
	}

	func test_getTimeslots_callsStore() {
		let (store, sut) = makeSUT()

		sut.getTimeslots(userID: someUserID) { _ in }

		XCTAssertEqual(store.getTimeslotsCallCount, 1)
	}

	func test_getTimeslots_deliversErrorOnStoreError() {
		let (store, sut) = makeSUT()

		expect(sut: sut, toCompleteWith: anyError, when: {
			store.completeGetTimeslots(with: anyError)
		})
	}

	func test_getTimeslots_deliversResultsOnSuccess() {
		let (store, sut) = makeSUT()

		let someTimeslots = uniqueTimeslots

		expect(sut: sut, toCompleteWith: someTimeslots, when: {
			store.completeGetTimeslots(with: someTimeslots)
		})
	}

	func test_getTimeslots_doesNotGetCalledAfterSUTHasBeenDeinitialized() {
		let store = TimeslotsStoreSpy()
		var sut: TimeslotsLoader? = RemoteTimeslotsLoader(store: store)

		var receivedResults: [Result<[TimeSlot], Error>] = []
		sut?.getTimeslots(userID: someUserID) { result in
			receivedResults.append(result)
		}

		sut = nil
		store.completeGetTimeslots(with: anyError)

		XCTAssert(receivedResults.isEmpty)
	}

	// MARK: - Helpers

	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (TimeslotsStoreSpy, TimeslotsLoader) {
		let store = TimeslotsStoreSpy()
		let sut = RemoteTimeslotsLoader(store: store)

		trackForMemoryLeaks(store, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)

		return (store, sut)
	}

	private func expect(sut: TimeslotsLoader, toCompleteWith expectedTimeslots: [TimeSlot], when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
		let exp = expectation(description: "Wait for completion")
		var receivedTimeslots: [[TimeSlot]]? = nil
		sut.getTimeslots(userID: someUserID) { result in
			if let timeslots = try? result.get() {
				if receivedTimeslots == nil {
					receivedTimeslots = [timeslots]
				} else {
					receivedTimeslots?.append(timeslots)
				}
			}
			exp.fulfill()
		}
		action()
		wait(for: [exp], timeout: 0.1)

		XCTAssertEqual(receivedTimeslots?.count, 1)
		XCTAssertEqual(receivedTimeslots?[0], expectedTimeslots, file: file, line: line)
	}

	private func expect(sut: TimeslotsLoader, toCompleteWith expectedError: NSError?, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
		let exp = expectation(description: "Wait for completion")
		var receivedErrors: [NSError]? = nil
		sut.getTimeslots(userID: someUserID) { result in
			if case let .failure(error) = result {
				if receivedErrors == nil {
					receivedErrors = [error as NSError]
				} else {
					receivedErrors?.append(error as NSError)
				}
			}
			exp.fulfill()
		}
		action()
		wait(for: [exp], timeout: 0.1)

		XCTAssertEqual(receivedErrors?.count, 1)
		XCTAssertEqual(receivedErrors?[0], expectedError, file: file, line: line)
	}

}
