//
//  ProjectListTableViewCell.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 31.01.2022.
//

import UIKit

class ProjectListCell: UITableViewCell {

    @IBOutlet var projectName: UILabel!
    @IBOutlet var projectClient: UIView!
    @IBOutlet var projectUsers: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
