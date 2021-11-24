
public protocol ClientsLoader {
	var store: ClientsStore { get }

	func getClients(completion: @escaping ClientsStore.GetClientsResult)
}

class RemoteClientsLoader: ClientsLoader {
	let store: ClientsStore

	init(store: ClientsStore) {
		self.store = store
	}

	func getClients(completion: @escaping ClientsStore.GetClientsResult) {
		store.getClients(completion: completion)
	}
}
