//
//  ProjectsTableViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 25.01.2022.
//

import UIKit
import TimeTrackerCore

class ClientsTableViewController: UITableViewController {

    var clients: [Client] = [] {
        didSet { tableView.reloadData() }
    }

    let clientsLoader = FirebaseClientsLoader(store: FirebaseClientsStore())

    override func viewDidLoad() {
        super.viewDidLoad()
        configRefreshControl()
        loadClientsData()
    }

    func loadClientsData() {
        clientsLoader.getClients { result in
            if let clients = try? result.get() {
                self.clients = clients
            }
        }
    }
}

extension ClientsTableViewController {
    static let clientCellIdentifier = "ClientListCell"
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.clientCellIdentifier,
                                                       for: indexPath) as? ClientListCell else {
            fatalError("Unable to deque client Cell")
        }

        // temporary leave it like this
        let clientRandomAvatarUrl = URL(string: "https://avatars.dicebear.com/api/miniavs/client.png")

        let clientCell = clients[indexPath.row]
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: clientRandomAvatarUrl! ),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.clientsAvatar.image = image
                }
            } else {
                cell.clientsAvatar.image = UIImage(systemName: "xmark.icloud")!
            }
        }
        var projects = [String]()
        clientCell.projects.forEach { project in
            projects.append(project.name)
        }

        cell.clientName.text = clientCell.name
        cell.clientsProject.text = "\(projects)"

        return cell
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        present(ClientsDetailViewController(), animated: true)
//
//    }

    func configRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        loadClientsData()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}
