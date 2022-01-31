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

    override func viewDidLoad() {
        super.viewDidLoad()
        loadClientPicker()
        clientPickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
    }
    @IBAction func createProjectButtonPressed(_ sender: Any) {
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
}
