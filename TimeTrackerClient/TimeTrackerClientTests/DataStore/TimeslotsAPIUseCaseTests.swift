
import XCTest
import TimeTrackerClient

class TimeslotsStore {

	typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void

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

class TimeslotsLoader {

	let store: TimeslotsStore

	var timeslotsUpdated: (() -> Void)?
	var timeslots: [TimeSlot] = [] {
		didSet {
			timeslotsUpdated?()
		}
	}

	init(store: TimeslotsStore) {
		self.store = store
	}

	func getTimeslots(completion: TimeslotsStore.GetTimeslotsResult? = nil) {
		store.getTimeslots { [weak self] result in
			guard let self = self else { return }
			let timeslots = try? result.get()
			self.timeslots = timeslots ?? []
			completion?(result)
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

		sut.getTimeslots()

		XCTAssertEqual(store.getTimeslotsCallCount, 1)
	}

	func test_getTimeslots_deliversEmptyResultsOnError() {
		let (store, sut) = makeSUT()

		expect(sut: sut, toCompleteWith: [], when: {
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

	func test_timeslots_isEmptyOnErrorAfterSuccess() {
		let (store, sut) = makeSUT()

		let exp = expectation(description: "Wait for completion")
		exp.expectedFulfillmentCount = 2
		sut.getTimeslots() { _ in
			exp.fulfill()
		}
		store.completeGetTimeslots(with: uniqueTimeslots)
		store.completeGetTimeslots(with: anyError)
		wait(for: [exp], timeout: 0.1)

		XCTAssertEqual(sut.timeslots, [])
	}

	func test_getTimeslots_doesNotGetCalledAfterSUTHasBeenDeinitialized() {
		let store = TimeslotsStore()
		var sut: TimeslotsLoader? = TimeslotsLoader(store: store)

		var receivedResults: [Result<[TimeSlot], Error>] = []
		sut?.getTimeslots() { result in
			receivedResults.append(result)
		}

		sut = nil
		store.completeGetTimeslots(with: anyError)

		XCTAssert(receivedResults.isEmpty)
	}

	func test_timeslotsUpdated_getsCalledOnTimeslotChanges() {
		let (store, sut) = makeSUT()

		let updateTimeslotsExp = expectation(description: "Wait for update timeslots completion")
		sut.timeslotsUpdated = {
			updateTimeslotsExp.fulfill()
		}

		let getTimeslotsExp = expectation(description: "Wait for completion")
		sut.getTimeslots(completion: { _ in
			getTimeslotsExp.fulfill()
		})
		store.completeGetTimeslots(with: anyError)
		wait(for: [getTimeslotsExp, updateTimeslotsExp], timeout: 0.1)
	}


	// MARK: - Helpers

	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (TimeslotsStore, TimeslotsLoader) {
		let store = TimeslotsStore()
		let sut = TimeslotsLoader(store: store)

		return (store, sut)
	}

	private func expect(sut: TimeslotsLoader, toCompleteWith expectedTimeslots: [TimeSlot], when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
		let exp = expectation(description: "Wait for completion")
		sut.getTimeslots { _ in
			exp.fulfill()
		}
		action()
		wait(for: [exp], timeout: 0.1)

		XCTAssertEqual(sut.timeslots, expectedTimeslots, file: file, line: line)
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

}
