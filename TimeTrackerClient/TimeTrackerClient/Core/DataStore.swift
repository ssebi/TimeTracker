//
//  DataStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation
import Firebase

class DataStore: ObservableObject {
	@Published var userTimeslots = [TimeSlot]()

    let db = Firestore.firestore()


	private let clientLoader: ClientsLoader
	private let timeslotsPublisher: TimeSlotsPublisher
	private let userLoader: UserLoader

	init(
		clientLoader: ClientsLoader = FirebaseClientsLoader(),
		timeslotsPublisher: TimeSlotsPublisher = FirebaseTimeslotsPublisher(),
		userLoader: UserLoader = FirebaseUserLoader()
	) {
		self.clientLoader = clientLoader
		self.timeslotsPublisher = timeslotsPublisher
		self.userLoader = userLoader
	}

    func addTimeSlot(timeSlot: TimeSlot, to path: String, completion: @escaping TimeSlotsPublisher.Result) {
        timeslotsPublisher.addTimeSlots(timeSlot: timeSlot, to: path, completion: completion)
	}

	func getUser() -> User {
		userLoader.getUser()
	}
}

/*
 We keep this as a reference
 but we need to remove it after we're done with the transition
class DataStoree: ObservableObject {
    @Published var timeslot: String = ""
    @Published var userTimeslots = [TimeSlot]()
    @Published var clients = [Client]()
    @Published var id: UUID = UUID()
    @Published var selectedClient: Int = 0 {
        didSet {
            selectedProject = projectSelections[selectedClient] ?? 0
            id = UUID()
        }
    }
    @Published var selectedProject: Int = 0 {
        didSet {
            DispatchQueue.main.async { [selectedProject] in
                self.projectSelections[self.selectedClient] = selectedProject
            }
        }
    }
    let db = Firestore.firestore()
    private var projectSelections: [Int: Int] = [:]
    var clientsNames: [String] {
        clients.map { (project) in
            project.name
        }
    }
    var projectNamesCount: Int {
        projectNames.count
    }
    var projectNames: [String] {
		guard !clients.isEmpty else {
			return [String]()
		}
        return clients[selectedClient].projects.map { (project) in
            return project.name
        }
    }

    //MARK: - Functions

    func addTimeSlot(with data: [String: Any], to path: String, completion: @escaping (Error?) -> Void) {
        db.collection(path).document().setData(data) { error in
            completion(error)
        }
    }
    
    func fetchUsersTimeslots() {
        let path = "userId/YErySzP9KBgMsFw64rHrimFAUBZ2/clients/Client 1/projects/Project 1/timeLogged/04-11-2021/timeslots"
        Firestore.firestore().collection(path).addSnapshotListener { [weak self] (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self?.userTimeslots = querySnapshot.documents.compactMap { document in
                    return try? document.data(as: TimeSlot.self)
                }
            }
        }
    }

    func fetchUsersClients() {
        let path = "Clients"
        db.collection(path).addSnapshotListener { [weak self] (querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                self?.clients = querySnapshot.documents.compactMap{ document in
                    let data = document.data()
                    let name = data["name"]
                    let id = data["id"]
                    var project = [Project]()
                    guard let projects = data["projects"] as? [String] else {
                        return nil
                    }
                    projects.forEach{ p in
                        project.append(Project(name: "\(p)"))
                    }
                    return Client(id: id as! Int, name: name as! String, projects: project)
                }
            }
        }
    }
}
*/
