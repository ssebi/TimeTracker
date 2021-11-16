
public protocol ClientsLoader {
	typealias Result = (Swift.Result<[Client], Error>) -> Void

	func getClients(completion: @escaping Result)
}
