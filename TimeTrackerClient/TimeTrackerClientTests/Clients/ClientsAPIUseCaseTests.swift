
import XCTest
import TimeTrackerClient

class ClientsStore {
	private(set) var getClientsCallCount = 0

	func getClients() {
		getClientsCallCount += 1
	}
}

class RemoteClientsLoader {
	private let store: ClientsStore

	init(store: ClientsStore) {
		self.store = store
	}

	func getClients() {
		store.getClients()
	}
}

class ClientsAPIUseCaseTests: XCTestCase {

	func test_init_doesNotMessageStore() {
		let (_, store) = makeSUT()

		XCTAssertEqual(store.getClientsCallCount, 0)
	}

	func test_getClients_callsStore() {
		let (sut, store) = makeSUT()

		sut.getClients()

		XCTAssertEqual(store.getClientsCallCount, 1)
	}

	// MARK: - Helpers

	private func makeSUT() -> (RemoteClientsLoader, ClientsStore) {
		let store = ClientsStore()
		let sut = RemoteClientsLoader(store: store)

		return (sut, store)
	}

}
