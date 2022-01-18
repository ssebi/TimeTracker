//
//  UserDetailViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 18.01.2022.
//

import UIKit

class UserDetailViewController: UIViewController {

    var userDetail: UserCell? = nil

    var safeArea: UILayoutGuide!
    let profilePicture: UIImageView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        safeArea = view.layoutMarginsGuide
    }

    func setProfilePicture() {
        guard let image = profilePicture else { return }
        view.addSubview(image)

        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50).isActive = true
    }
}
