
import FirebaseFirestore

public class FirebaseClientsStore: ClientsStore {
    public init(){}

    public struct UndefinedError: Error { }

    public func getClients(completion: @escaping ClientsStore.GetClientsResult) {
        Firestore.firestore().collection(Path.clients).getDocuments { snapshot, error in
            if let snapshot = snapshot {
                let clients = snapshot.documents.compactMap { document -> Client? in
                    let data = document.data()
                    var project = [Project]()
                    guard let name = data["name"] as? String,
                          let projects = data["projects"] as? [String],
                            let vat = data["vat"] as? String,
                            let country = data["country"] as? String,
                            let address = data["address"] as? String else {
                              return nil
                          }
                    projects.forEach { name in
                        project.append(Project(name: name))
                    }
                    return Client(id: document.documentID,
                                  name: name,
                                  projects: project,
                                  vat: vat,
                                  address: address,
                                  country: country)
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
