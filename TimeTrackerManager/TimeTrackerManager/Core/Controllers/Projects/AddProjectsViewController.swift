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
    var clientPickerData: [String] = [String]()

    let clientsLoader = FirebaseClientsLoader(store: FirebaseClientsStore())

    override func viewDidLoad() {
        super.viewDidLoad()
        loadClientsData()
        loadClientPicker()
        NotificationCenter.default.addObserver(self, selector: #selector(AddProjectsViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(AddProjectsViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @IBAction func createProjectButtonPressed(_ sender: Any) {

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
        return clientPickerData[row]
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
                clients.forEach { client in
                    self.clientPickerData.append(client.name)
                }
            }
        }
    }
}
