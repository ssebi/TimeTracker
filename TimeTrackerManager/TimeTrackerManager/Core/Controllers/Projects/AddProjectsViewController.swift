//
//  AddProjectsViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 31.01.2022.
//

import UIKit
import TimeTrackerCore

final class AddProjectsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet private var projectName: UITextField!
    @IBOutlet private var clientPicker: UIPickerView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!

    private var clientPickerData = [String: String]()
    private let projectsPublisher = FirebaseProjectPublisher()
    private let clientsLoader = FirebaseClientsLoader(store: FirebaseClientsStore())
    private var selectedClient = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadClientsData()
        configureClientPicker()
        activityIndicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(AddProjectsViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(AddProjectsViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction private func createProjectButtonPressed(_ sender: Any) {
        toggleSpiner(isHidden: false)
        guard projectName.hasText, !selectedClient.isEmpty else {
            self.validationError(title: "Error", message: "Please fill in all fields", hasError: true)
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
    private func configureClientPicker() {
        self.clientPicker.delegate = self
        self.clientPicker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        clientPickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Array(self.clientPickerData)[row].value
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedClient = Array(self.clientPickerData)[row].key
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                    as? NSValue)?.cgRectValue else { return }
        self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    private func loadClientsData() {
        clientsLoader.getClients { result in
            if let clients = try? result.get() {
                clients.forEach { [weak self] client in
                    self?.clientPickerData[client.id] = client.name
                    self?.configureClientPicker()
                }
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

    private func validationError(title: String, message: String, hasError: Bool) {
        self.toggleSpiner(isHidden: true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            if !hasError { self.dismisView() }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func dismisView() {
        self.navigationController?.popViewController(animated: true)
    }
}
