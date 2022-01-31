//
//  SettingsViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 31.01.2022.
//

import UIKit
import TimeTrackerAuth
import TimeTrackerCore

class SettingsViewController: UIViewController {
    var isLoading = true
    var sceneDelegate = SceneDelegate()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var userName: UILabel!

    @IBAction func signOutButtonPressed(_ sender: Any) {
        sceneDelegate.session.signOut()
        print("power pressed")
    }
}
