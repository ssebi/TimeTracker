
import XCTest
@testable import TimeTrackerClient

class ClientsStore {
	private(set) var getClientsCallCount = 0

	private var getClientsResult: Result<[Client], Error>?

	func getClients(completion: @escaping (Result<[Client], Error>) -> Void) {
		getClientsCallCount += 1
		if let result = getClientsResult {
			completion(result)
		}
	}

	func completeGetClients(with error: Error) {
		getClientsResult = .failure(error)
	}

	func completeGetClients(with clients: [Client]) {
		getClientsResult = .success(clients)
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

	func test_getClients_returnsFailureOnStoreError() {
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

	func test_getClients_returnsClientsOnStoreSuccess() throws {
		let (sut, store) = makeSUT()
		let someClients = [Client(id: UUID().uuidString, name: "Client1", projects: []),
						   Client(id: UUID().uuidString, name: "Client2", projects: [])]
		var receivedClients: [Client]? = nil

		store.completeGetClients(with: someClients)
		sut.getClients { result in
			receivedClients = try? result.get()
		}

		XCTAssertEqual(receivedClients, someClients)
	}

	// MARK: - Helpers

	private func makeSUT() -> (RemoteClientsLoader, ClientsStore) {
		let store = ClientsStore()
		let sut = RemoteClientsLoader(store: store)

		return (sut, store)
	}

	private lazy var someError = NSError(domain: "Test", code: 0)

}
