
import XCTest

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
		let store = ClientsStore()
		let _ = RemoteClientsLoader(store: store)

		XCTAssertEqual(store.getClientsCallCount, 0)
	}

	func test_getClients_callsStore() {
		let store = ClientsStore()
		let sut = RemoteClientsLoader(store: store)

		sut.getClients()

		XCTAssertEqual(store.getClientsCallCount, 1)
	}

}
