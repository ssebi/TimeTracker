//
//  AddProjectsViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 31.01.2022.
//

import UIKit
import TimeTrackerCore

class AddProjectsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var projectName: UITextField!
    @IBOutlet var clientPicker: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var clientPickerData = [String: String]()
    let projectsPublisher = FirebaseProjectPublisher()
    let clientsLoader = FirebaseClientsLoader(store: FirebaseClientsStore())
    var selectedClient = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadClientsData()
        loadClientPicker()
        activityIndicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(AddProjectsViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(AddProjectsViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func createProjectButtonPressed(_ sender: Any) {
        toggleSpiner(isHidden: false)
        guard projectName.text != nil else {
            self.validationError(title: "Error", message: "Something went wrong", hasError: true)
            return
        }

        projectsPublisher.createProject(projectName.text!, client: selectedClient) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.validationError(title: "Success", message: "Project Created", hasError: false)
            case .failure(let error):
                self.validationError(title: "Error", message: "Something went wrong: \(error)", hasError: true)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AddProjectsViewController {
    private func loadClientPicker() {
        self.clientPicker.delegate = self
        self.clientPicker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clientPickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.clientPickerData)[row].value
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return self.selectedClient = Array(self.clientPickerData)[row].key
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                    as? NSValue)?.cgRectValue else {
            return
        }
        self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    func loadClientsData() {
        clientsLoader.getClients { result in
            if let clients = try? result.get() {
                clients.forEach { [weak self] client in
                    self?.clientPickerData[client.id] = client.name
                    self?.loadClientPicker()
                }
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
