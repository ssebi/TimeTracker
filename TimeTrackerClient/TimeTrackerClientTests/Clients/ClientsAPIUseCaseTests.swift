
import XCTest
@testable import TimeTrackerClient


private class ClientsStoreSpy: ClientsStore {

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

		let receivedResult = resultFor(sut: sut) {
			store.completeGetClients(with: someError)
		}

		switch receivedResult {
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

		let result = resultFor(sut: sut) {
			store.completeGetClients(with: someClients)
		}
		receivedClients = try result.get()

		XCTAssertEqual(receivedClients, someClients)
	}

	// MARK: - Helpers

	private func makeSUT() -> (ClientsLoader, ClientsStoreSpy) {
		let store = ClientsStoreSpy()
		let sut = RemoteClientsLoader(store: store)

		return (sut, store)
	}

	private func resultFor(sut: ClientsLoader, when action: () -> Void) -> Result<[Client], Error> {
		let exp = expectation(description: "Wait for completion")
		var receivedResult: Result<[Client], Error>?
		sut.getClients() { result in
			receivedResult = result
			exp.fulfill()
		}
		action()
		wait(for: [exp], timeout: 0.1)
		return receivedResult!
	}

	private lazy var someError = NSError(domain: "Test", code: 0)

}
