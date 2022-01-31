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
    var projects = [ProjectCell]()
    var clients = [Client]()
    typealias GetProjectsResult = (Result<[ProjectCell], Error>) -> Void

    func getProjects() -> [ProjectCell] {
        clientsLoader.getClients { result in
            if let clients = try? result.get() {
                clients.forEach { client in
                    client.projects.forEach { project in
                        let project = ProjectCell(name: project.name, client: client.name)
                        self.projects.append(project)
                    }
                }
            }
        }
        return projects
    }
}
