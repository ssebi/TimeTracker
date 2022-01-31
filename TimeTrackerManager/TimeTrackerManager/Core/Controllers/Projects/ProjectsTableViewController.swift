//
//  ProjectsViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 31.01.2022.
//

import UIKit
import TimeTrackerCore
import SwiftUI

class ProjectsTableViewController: UITableViewController {

    var projectLoader = FirebaseProjectsLoader()
    var projects: [ProjectCell] = [] {
        didSet { tableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadProjectsData()
        configRefreshControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func loadProjectsData() {
        projectLoader.getProjects { [weak self] result in
            self?.projects = result
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
        cell.projectUsers.text = "1"
        return cell
    }

    func configRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        loadProjectsData()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}