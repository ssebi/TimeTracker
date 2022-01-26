//
//  AddProjectsViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 25.01.2022.
//

import UIKit

class AddClientsViewController: UIViewController {

    @IBOutlet var clientName: UITextField!
    @IBOutlet var clientProject: UITextField!
    let clientPublisher = FirebaseClientPublisher()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func addClientButtonPressed(_ sender: Any) {
        clientPublisher.createClient(clientName.text ?? "", project: clientProject.text ?? "") { _ in
        }
    }
}
