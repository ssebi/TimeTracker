//
//  UserListCell.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 20.12.2021.
//

import UIKit

final class UserListCell: UITableViewCell {

    @IBOutlet var userName: UILabel!
    @IBOutlet var userProfilePicture: UIImageView!
    @IBOutlet var userProjects: UILabel!
    @IBOutlet var hourRate: UITextView!
    @IBOutlet var totalHours: UITextView!

}
