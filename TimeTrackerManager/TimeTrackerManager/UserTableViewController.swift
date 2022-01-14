//
//  UserTableViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 20.12.2021.
//

import UIKit

class UserTableViewController: UITableViewController {

    var userLoader = FirebaseUserLoader()
    var users: [User] = [] {
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
            if let user = try? result.get() {
                self.users = user
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
        cell.userName.text = userCell.firstName
        cell.userProfilePicture.image = UIImage(systemName: "person.fill.viewfinder")

        return cell
    }
}
