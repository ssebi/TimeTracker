//
//  UserTableViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 20.12.2021.
//

import UIKit
import TimeTrackerCore

class UserTableViewController: UITableViewController {

    var userLoader = FirebaseUsersLoader(store: FirebaseTimeslotsStore())
    var users: [UserCell] = [] {
        didSet { tableView.reloadData() }
    }
    // Data
    @IBOutlet var UserTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: - Table view data source
    func loadUserData() {
        userLoader.getUsers() { result in
            if let users = try? result.get() {
                self.users = users
            }
        }
    }
}

extension UserTableViewController {
    static let usersCellIdentifier = "UserListCell"

    //TODO: use new api for tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.usersCellIdentifier, for: indexPath) as? UserListCell else {
            fatalError("Unable to deque UserCell")
        }

        let userCell = users[indexPath.row]

        let url = URL(string: "https://avatars.dicebear.com/api/bottts/xx.png")
        DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        cell.userProfilePicture.image = UIImage(data: data)!
                    }
                }
            }

        cell.userName.text = userCell.name
        cell.totalHours.text = "\(userCell.totalHours ?? 0)"
        cell.hourRate.text = userCell.hourRate
        cell.userProjects.text = userCell.projects

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let userCell = users[indexPath.row]
        if editingStyle == .delete {
            self.users.remove(at: indexPath.row)
            userLoader.deleteUser(userCell.documentId)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetail = users[indexPath.row]
        let userDetailVC = UserDetailViewController()
        userDetailVC.userDetail = userDetail
        self.present(userDetailVC, animated: true)
    }
}
