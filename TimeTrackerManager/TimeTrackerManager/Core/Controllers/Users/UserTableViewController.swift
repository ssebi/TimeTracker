//
//  UserTableViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 20.12.2021.
//

import UIKit
import TimeTrackerCore

final class UserTableViewController: UITableViewController {

    private var userLoader = FirebaseUsersLoader(store: FirebaseTimeslotsStore())
    typealias CompletionHandler = (_ success: Bool) -> Void
    private var users: [UserCell] = [] {
        didSet { tableView.reloadData() }
    }
    // Data
    @IBOutlet private var userTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.tintColor = .white
        loadUserData {_ in}
        configRefreshControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: - Table view data source
    private func loadUserData(completion: @escaping CompletionHandler) {
        userLoader.getUsers { result in
            if let users = try? result.get() {
                self.users = users
                completion(true)
            }
        }
    }
}

extension UserTableViewController {
    static let usersCellIdentifier = "UserListCell"

    // tod: use new api for tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Self.usersCellIdentifier,
                for: indexPath) as? UserListCell else {
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
						cell.totalHours.text = "Total h:\(totalHours)"
                        cell.userProjects.text = allProjects.joined(separator: ", ")
					}
				}
			}
		}

        return cell
    }

    override func tableView(
            _ tableView: UITableView,
            commit editingStyle: UITableViewCell.EditingStyle,
            forRowAt indexPath: IndexPath) {

        let userCell = users[indexPath.row]
        if editingStyle == .delete {
            self.users.remove(at: indexPath.row)
            userLoader.deleteUser(userCell.documentId)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(UserDetailViewController(userDetail: users[indexPath.row]), animated: true)
    }

    private func configRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc private func handleRefreshControl() {
        loadUserData { success in
            if success {
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
}
