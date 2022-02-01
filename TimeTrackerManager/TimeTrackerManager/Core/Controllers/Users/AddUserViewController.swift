//
//  AddUserViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 15.12.2021.
//

import UIKit
import Firebase

final class AddUserViewController: UIViewController {

    @IBOutlet private var firsNameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var lastNameTextField: UITextField!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!

    private var user = FirebaseUserPublisher()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(AddUserViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(AddUserViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func toggleSpiner(isHidden: Bool) {
        activityIndicator.isHidden = isHidden
        if isHidden == true {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }

    @IBAction private func createUserButtonPressed(_ sender: Any) {
        self.toggleSpiner(isHidden: false)
        user.addUser(
                email: self.emailTextField?.text ?? "",
                password: "Balonas1",
                firstName: firsNameTextField.text ?? "",
                lastName: lastNameTextField.text ?? "" ) { [weak self] result in

            guard let self = self else { return }
            switch result {
            case .success:
                self.validationError(title: "Success", message: "User Created", hasError: false)

            case .failure(let error):
                if error == FirebaseUserPublisher.UserPublisherError.passwordResetFailed {
                    self.validationError(title: "Error", message: "Please validate user", hasError: true)
                } else {
                    self.validationError(title: "Error", message: "Something went wrong", hasError: true)
                }
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
}

extension AddUserViewController {
    private func validationError(title: String, message: String, hasError: Bool) {
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
