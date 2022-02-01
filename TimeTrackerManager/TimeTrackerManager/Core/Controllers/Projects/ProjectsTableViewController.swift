//
//  ProjectsViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 31.01.2022.
//

import UIKit
import TimeTrackerCore
import SwiftUI

final class ProjectsTableViewController: UITableViewController {

    private var projectLoader = FirebaseProjectsLoader()
    typealias CompletionHandler = (_ success: Bool) -> Void
    private var projects: [ProjectCell] = [] {
        didSet { tableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadProjectsData {_ in}
        configRefreshControl()
    }

    private func loadProjectsData(completion: @escaping CompletionHandler) {
        projectLoader.getProjects { [weak self] result in
            self?.projects = result
            completion(true)
        }
    }
}

extension ProjectsTableViewController {
    static let cellIdentifier = "ProjectListCell"

    // tod: use new api for tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Self.cellIdentifier,
                for: indexPath) as? ProjectListCell else {
            fatalError("Unable to deque ProjectCell")
        }

        let projectCell = projects[indexPath.row]
        cell.projectName.text = projectCell.name
        cell.projectClient.text = "owned by \(projectCell.client)"
        cell.projectUsers.text = "1 dev(s)"
        return cell
    }

    private func configRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc private func handleRefreshControl() {
        loadProjectsData { success in
            if success {
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }

    }
}
