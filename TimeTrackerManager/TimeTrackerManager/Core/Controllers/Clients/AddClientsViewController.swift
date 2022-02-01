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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let clientPublisher = FirebaseClientPublisher()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true

    }
    @IBAction func addClientButtonPressed(_ sender: Any) {
        toggleSpiner(isHidden: false)
        guard clientName.text?.isEmpty == false,
              clientProject.text?.isEmpty == false else {
            self.validationError(title: "Error", message: "Please fill in all fields", hasError: true)
            return
        }
        clientPublisher.createClient(clientName.text!, project: clientProject.text! ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.validationError(title: "Success", message: "Client Created", hasError: false)
            case .failure(let error):
                self.validationError(title: "Error", message: "Something went wrong: \(error)", hasError: true)
            }

        }
    }

    func toggleSpiner(isHidden: Bool) {
        activityIndicator.isHidden = isHidden
        if isHidden == true {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
}

extension AddClientsViewController {
    func validationError(title: String, message: String, hasError: Bool) {
        self.toggleSpiner(isHidden: true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            if !hasError { self.dismisView() }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func dismisView() {
        self.navigationController?.popViewController(animated: true)
    }
}
