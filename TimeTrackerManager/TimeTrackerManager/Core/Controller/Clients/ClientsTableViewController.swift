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
        loadClientsData()
    }

    func loadClientsData() {
        clientsLoader.getClients() { result in
            if let clients = try? result.get() {
                self.clients = clients
            }
        }
    }

    // MARK: - Table view data source
    static let clientCellIdentifier = "ClientListCell"

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.clientCellIdentifier, for: indexPath) as? ClientListCell else {
            fatalError("Unable to deque UserCell")
        }

        let userCell = users[indexPath.row]
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: userCell.profilePictureURLOrDefault),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.userProfilePicture.image = image
                }
            } else {
                cell.userProfilePicture.image = UIImage(systemName: "xmark.icloud")!
            }
        }

        cell.userName.text = userCell.name
        cell.hourRate.text = userCell.hourRate

        DispatchQueue.global().async {
            userCell.timeSlots?(userCell.userId) { result in
                var totalHours = 0
                var allProjects = Set<String>()

                if let success = try? result.get() {
                    success.forEach { timeSlot in
                        totalHours += timeSlot.total
                        allProjects.insert(timeSlot.projectName)
                    }
                    DispatchQueue.main.async {
                        cell.totalHours.text = "\(totalHours)"
                        cell.userProjects.text = "\(allProjects)"
                    }
                }
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let clientCell = clients[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(UserDetailViewController(userDetail: clients[indexPath.row]), animated: true)
    }
}
