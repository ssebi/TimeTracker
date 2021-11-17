
import Firebase

class FirebaseClientsLoader: ClientsLoader {
    let db = Firestore.firestore()
    var clients = [Client]()

	func getClients(completion: @escaping ClientsLoader.Result) {
        db.collection(Path.clients).addSnapshotListener { [weak self] (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
            self?.clients = querySnapshot.documents.compactMap{ document in
                    let data = document.data()
                    let name = data["name"]
                    var project = [Project]()
                    guard let projects = data["projects"] as? [String] else {
                        return nil
                    }
                    projects.forEach{ projectName in
                        project.append(Project(name: "\(projectName)"))
                    }
                return Client(id: document.documentID, name: name as! String, projects: project)
                }
                completion(.success(self!.clients))
            } else {
                completion(.failure(error!))
            }
        }
	}
}
