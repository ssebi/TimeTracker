
import XCTest
import TimeTrackerClient

public protocol TimeslotsStore {

	typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void

	func getTimeslots(completion: @escaping GetTimeslotsResult)

}

class TimeslotsLoader {

	let store: TimeslotsStore

	init(store: TimeslotsStore) {
		self.store = store
	}

	func getTimeslots(completion: @escaping TimeslotsStore.GetTimeslotsResult) {
		store.getTimeslots { [weak self] result in
			guard self != nil else { return }
			completion(result)
		}
	}

}

class TimeslotsAPIUseCaseTests: XCTestCase {

	func test_init_doesNotMessageStore() {
		let (store, _) = makeSUT()

		XCTAssertEqual(store.getTimeslotsCallCount, 0)
	}

	func test_getTimeslots_callsStore() {
		let (store, sut) = makeSUT()

		sut.getTimeslots { _ in }

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
		var sut: TimeslotsLoader? = TimeslotsLoader(store: store)

		var receivedResults: [Result<[TimeSlot], Error>] = []
		sut?.getTimeslots() { result in
			receivedResults.append(result)
		}

		sut = nil
		store.completeGetTimeslots(with: anyError)

		XCTAssert(receivedResults.isEmpty)
	}

	// MARK: - Helpers

	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (TimeslotsStoreSpy, TimeslotsLoader) {
		let store = TimeslotsStoreSpy()
		let sut = TimeslotsLoader(store: store)

		return (store, sut)
	}

	private func expect(sut: TimeslotsLoader, toCompleteWith expectedTimeslots: [TimeSlot], when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
		let exp = expectation(description: "Wait for completion")
		var receivedTimeslots: [[TimeSlot]]? = nil
		sut.getTimeslots { result in
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
		sut.getTimeslots { result in
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

	private let anyError = NSError(domain: "any error", code: 0)

	private var uniqueTimeslots: [TimeSlot] {
		[
			uniqueTimeslot,
			uniqueTimeslot,
		]
	}

	private var uniqueTimeslot: TimeSlot {
		TimeSlot(id: UUID().uuidString,
				 userId: UUID().uuidString,
				 clientId: Int.random(in: 0...100),
				 projectId: Int.random(in: 0...100),
				 date: "2021-11-22T09:48:51Z",
				 details:
					TimeSlotDetails(
						start: "2021-11-22T09:48:51Z",
						end: "2021-11-22T09:48:51Z",
						description: "some description"),
				 total: Int.random(in: 0...100))
	}

	private class TimeslotsStoreSpy: TimeslotsStore {

		var getTimeslotsCallCount = 0

		private var completions: [GetTimeslotsResult] = []

		func getTimeslots(completion: @escaping GetTimeslotsResult) {
			getTimeslotsCallCount += 1
			completions.append(completion)
		}

		func completeGetTimeslots(with error: Error, at index: Int = 0) {
			completions[index](.failure(error))
		}

		func completeGetTimeslots(with timeslots: [TimeSlot], at index: Int = 0) {
			completions[index](.success(timeslots))
		}

	}

}
