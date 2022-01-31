//
//  FirebaseProjectsLoader.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 31.01.2022.
//

import Foundation
import TimeTrackerCore

class FirebaseProjectsLoader {

    let clientsLoader = FirebaseClientsLoader(store: FirebaseClientsStore())
    var clients = [Client]()
    typealias GetProjectsResult = (Result<[ProjectCell], Error>) -> Void

    func getProjects(completion: @escaping ([ProjectCell]) -> Void) {
        clientsLoader.getClients { result in
            var projects = [ProjectCell]()
            if let clients = try? result.get() {
                clients.forEach { client in
                    client.projects.forEach { project in
                        let project = ProjectCell(name: project.name, client: client.name)
                        projects.append(project)
                    }
                }
            }
            completion(projects)
        }
    }
}
