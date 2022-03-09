
public protocol UserLoader {
    typealias GetManagerResult = (Result<Manager, Error>) -> Void

	func getUser() -> User
    func getManager(companyEmail: String, completion: @escaping GetManagerResult)
}
