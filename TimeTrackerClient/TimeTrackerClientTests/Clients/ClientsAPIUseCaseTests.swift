
import XCTest
import TimeTrackerClient

class ClientsStore {
	private(set) var getClientsCallCount = 0

	private var getClientsResult: Error?

	func getClients(completion: @escaping (Result<[Client], Error>) -> Void) {
		getClientsCallCount += 1
		if let error = getClientsResult {
			completion(.failure(error))
		}
	}

	func completeGetClients(with error: Error) {
		getClientsResult = error
	}
}

class RemoteClientsLoader {
	private let store: ClientsStore

	init(store: ClientsStore) {
		self.store = store
	}

	func getClients(completion: @escaping (Result<[Client], Error>) -> Void) {
		store.getClients(completion: completion)
	}
}

class ClientsAPIUseCaseTests: XCTestCase {

	func test_init_doesNotMessageStore() {
		let (_, store) = makeSUT()

		XCTAssertEqual(store.getClientsCallCount, 0)
	}

	func test_getClients_callsStore() {
		let (sut, store) = makeSUT()

		sut.getClients() { _ in }

		XCTAssertEqual(store.getClientsCallCount, 1)
	}

	func test_getClients_returnsFailureOnLoaderError() {
		let (sut, store) = makeSUT()
		var receivedResult: (Result<[Client], Error>)?

		store.completeGetClients(with: someError)
		sut.getClients { result in
			receivedResult = result
		}

		switch receivedResult! {
			case .success:
				XCTFail()
			case .failure(let error):
				XCTAssertEqual(someError.domain, (error as NSError).domain)
				XCTAssertEqual(someError.code, (error as NSError).code)
		}
	}

	// MARK: - Helpers

	private func makeSUT() -> (RemoteClientsLoader, ClientsStore) {
		let store = ClientsStore()
		let sut = RemoteClientsLoader(store: store)

		return (sut, store)
	}

	private lazy var someError = NSError(domain: "Test", code: 0)

}
