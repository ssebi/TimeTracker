//
//  UserTableViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 20.12.2021.
//

import UIKit

class UserTableViewController: UITableViewController {

    var userLoader = UserLoader()
    var user: [User] = []
    // Data
    @IBOutlet var UserTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: - Table view data source
}

extension UserTableViewController {
    static let usersCellIdentifier = "UserListCell"

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserCell.testData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.usersCellIdentifier, for: indexPath) as? UserListCell else {
            fatalError("Unable to deque UserCell")
        }
        //let user = UserCell.testData[indexPath.row]

      userLoader.getUsers { result in
            if let user = try? result.get() {
                self.user = user
            }
        }

        let image = UIImage(systemName: "person.fill.viewfinder")

        //
        cell.userName.text = user[indexPath.row].firstName
        cell.userProfilePicture.image = image
        return cell
    }
}
