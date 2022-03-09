//
//  ViewController.swift
//  TimeTrackerManager
//
//  Created by Sebastian Vidrea on 09.12.2021.
//

import UIKit
import TimeTrackerAuth

final class LoginViewController: UIViewController {

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var errorLabel: UILabel!

    private lazy var session = SessionStore(authProvider: FirebaseAuthProvider())
    var isLoading = true

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
		super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
	}

    @IBAction private func tapOutside(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction private func logInButtonPressed(_ sender: Any) {
        session.signIn(email: emailTextField.text!, password: passwordTextField.text!) { [weak self] result in
            if case let .failure(result) =  result {
                self?.errorLabel.text = result.localizedDescription
			}
            if case .success = result {
                self?.performSegue(withIdentifier: "showMainTabBar", sender: self)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            logInButtonPressed(textField)
        }
        return true
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                    as? NSValue)?.cgRectValue else { return }
        self.view.frame.origin.y = 0 - keyboardSize.height / 2
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
