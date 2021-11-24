
import XCTest
@testable import TimeTrackerClient

class ClientsStore {
	typealias GetClientsResult = (Result<[Client], Error>) -> Void

	var getClientsCallCount: Int {
		completions.count
	}

	private var completions: [GetClientsResult] = []

	func getClients(completion: @escaping GetClientsResult) {
		completions.append(completion)
	}

	func completeGetClients(with error: Error, at index: Int = 0) {
		completions[index](.failure(error))
	}

	func completeGetClients(with clients: [Client], at index: Int = 0) {
		completions[index](.success(clients))
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

		let exp = expectation(description: "Wait for completion")
		sut.getClients { result in
			receivedResult = result
			exp.fulfill()
		}
		store.completeGetClients(with: someError)
		wait(for: [exp], timeout: 0.1)

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

		let exp = expectation(description: "Wait for completion")
		sut.getClients { result in
			receivedClients = try? result.get()
			exp.fulfill()
		}
		store.completeGetClients(with: someClients)
		wait(for: [exp], timeout: 0.1)

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
