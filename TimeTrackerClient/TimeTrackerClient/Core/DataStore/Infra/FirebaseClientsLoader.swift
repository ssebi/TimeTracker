
import Firebase

class FirebaseClientsStore: ClientsStore {

	struct UndefinedError: Error { }

	func getClients(completion: @escaping ClientsStore.GetClientsResult) {
		Firestore.firestore().collection(Path.clients).addSnapshotListener { snapshot, error in
			if let snapshot = snapshot {
				let clients = snapshot.documents.compactMap { document -> Client? in
					let data = document.data()
					var project = [Project]()
					guard let name = data["name"] as? String,
						  let projects = data["projects"] as? [String] else {
						return nil
					}
					projects.forEach { name in
						project.append(Project(name: name))
					}
					return Client(id: document.documentID, name: name, projects: project)
				}
				completion(.success(clients))
			} else if let error = error {
				completion(.failure(error))
			} else {
				completion(.failure(UndefinedError()))
			}
		}
	}

}
