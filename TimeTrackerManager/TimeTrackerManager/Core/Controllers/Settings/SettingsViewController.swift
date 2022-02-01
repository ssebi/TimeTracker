//
//  SettingsViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 31.01.2022.
//

import UIKit
import TimeTrackerAuth
import TimeTrackerCore

final class SettingsViewController: UIViewController {
    private var isLoading = true
    @IBOutlet private var profilePicture: UIImageView!
    @IBOutlet private var userName: UILabel!
    @IBAction func signOutButtonPressed(_ sender: Any) {
        SceneDelegate.session.signOut()
    }

}
