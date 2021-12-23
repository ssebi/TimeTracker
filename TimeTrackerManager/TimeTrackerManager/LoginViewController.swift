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
    var session: SessionStore
    var isLoading = true
    var firAuthProvider : FirebaseAuthProvider

    init(session: SessionStore, firAuthProvider: FirebaseAuthProvider){
        self.session = SessionStore(authProvider: firAuthProvider)
        self.firAuthProvider = firAuthProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.firAuthProvider = FirebaseAuthProvider()
        self.session = SessionStore(authProvider: firAuthProvider)
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

    @IBAction func logInButtonPressed(_ sender: Any) {
        session.signIn(email: emailTextField.text!, password: passwordTextField.text!) { [weak self] result in

            if case let .failure(result) =  result {
                //
            }
        }
    }
}

