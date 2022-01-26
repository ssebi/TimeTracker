//
//  ClientListCell.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 26.01.2022.
//

import UIKit

class ClientListCell: UITableViewCell {


    @IBOutlet var clientsAvatar: UIImageView!

    @IBOutlet var clientName: UILabel!
    
    @IBOutlet var clientsProject: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
