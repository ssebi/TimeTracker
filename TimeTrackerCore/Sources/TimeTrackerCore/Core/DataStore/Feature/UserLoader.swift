
public protocol UserLoader {
	func getUser() -> User
}

public protocol ManagerLoader {
    typealias GetManagerResult = (Result<Manager, Error>) -> Void
    func getManager(companyEmail: String) async throws -> Manager?
}
