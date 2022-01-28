//
//  AddUserViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 15.12.2021.
//

import UIKit
import Firebase

class AddUserViewController: UIViewController {

    @IBOutlet var firsNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var user = FirebaseUserPublisher()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(AddUserViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(AddUserViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func toggleSpiner(isHidden: Bool) {
        activityIndicator.isHidden = isHidden
        if isHidden == true {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }

    @IBAction func createUserButtonPressed(_ sender: Any) {
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
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                    as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }

        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}

extension AddUserViewController {
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
