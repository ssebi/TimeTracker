
public protocol ClientsLoader {
	var store: ClientsStore { get }

	func getClients(completion: @escaping ClientsStore.GetClientsResult)
}

public class RemoteClientsLoader: ClientsLoader {
	public let store: ClientsStore

	public init(store: ClientsStore) {
		self.store = store
	}

	public func getClients(completion: @escaping ClientsStore.GetClientsResult) {
		store.getClients(completion: completion)
	}
}
