//
//  ViewController.swift
//  TimeTrackerManager
//
//  Created by Sebastian Vidrea on 09.12.2021.
//

import UIKit
import TimeTrackerAuth

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!

    private lazy var session = SessionStore(authProvider: FirebaseAuthProvider())
    var isLoading = true

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

    @IBAction func logInButtonPressed(_ sender: Any) {
        session.signIn(email: emailTextField.text!, password: passwordTextField.text!) { [weak self] result in
            if case let .failure(result) =  result {
                self?.errorLabel.text = result.localizedDescription
			}
            if case .success(_) = result {
                self?.performSegue(withIdentifier: "showMainTabBar", sender: self)
            }
        }
    }
}

