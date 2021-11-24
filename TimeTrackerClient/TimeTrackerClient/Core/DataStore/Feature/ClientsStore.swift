
public protocol ClientsStore {
	typealias GetClientsResult = (Result<[Client], Error>) -> Void

	func getClients(completion: @escaping GetClientsResult)
}

