//
//  AddProjectsViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 25.01.2022.
//

import UIKit
import TimeTrackerCore

final class AddClientsViewController: UIViewController {

    @IBOutlet private var clientName: UITextField!
    @IBOutlet private var clientProject: UITextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var vatNo: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var country: UITextField!
    @IBOutlet var hourRate: UITextField!
    private let clientPublisher = FirebaseClientPublisher()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true

    }
    @IBAction private func addClientButtonPressed(_ sender: Any) {
        toggleSpiner(isHidden: false)
        guard clientName.text?.isEmpty == false,
              clientProject.text?.isEmpty == false,
              vatNo.text?.isEmpty == false,
        address.text?.isEmpty == false,
        country.text?.isEmpty == false,
        let hourRate = Int(hourRate.text ?? "0") else {
            self.validationError(title: "Error", message: "Please fill in all fields", hasError: true)
            return
        }

        clientPublisher.createClient(clientName.text!,
                                     clientProject.text!,
                                     vatNo.text!,
                                     address.text!,
                                     country.text!,
                                     hourRate) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success:
                    self.validationError(title: "Success", message: "Client Created", hasError: false)
                case .failure(let error):
                    self.validationError(title: "Error", message: "Something went wrong: \(error)", hasError: true)
            }

        }
    }

    private func toggleSpiner(isHidden: Bool) {
        activityIndicator.isHidden = isHidden
        if isHidden == true {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
}

extension AddClientsViewController {
    private func validationError(title: String, message: String, hasError: Bool) {
        self.toggleSpiner(isHidden: true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {[weak self] _ in
            if !hasError { self?.dismisView() }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func dismisView() {
        self.navigationController?.popViewController(animated: true)
    }
}
