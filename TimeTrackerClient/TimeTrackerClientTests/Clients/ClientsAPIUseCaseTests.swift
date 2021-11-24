
import XCTest

class ClientsStore {
	private(set) var getClientsCallCount = 0
}

class RemoteClientsLoader {
	private let store: ClientsStore

	init(store: ClientsStore) {
		self.store = store
	}
}

class ClientsAPIUseCaseTests: XCTestCase {

	func test_init_doesNotMessageStore() {
		let store = ClientsStore()
		let _ = RemoteClientsLoader(store: store)

		XCTAssertEqual(store.getClientsCallCount, 0)
	}

}
