//
//  UserListCell.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 20.12.2021.
//

import UIKit

class UserListCell: UITableViewCell {

    @IBOutlet var userName: UILabel!
    @IBOutlet var userProfilePicture: UIImageView!
    @IBOutlet var userProjects: UILabel!
    @IBOutlet var hourRate: UITextView!
    @IBOutlet var totalHours: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
