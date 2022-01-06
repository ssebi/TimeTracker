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

    override func viewDidLoad() {
        super.viewDidLoad()

        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(AddUserViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

          // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(AddUserViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func createUserButtonPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text ?? "", password: "Patratel1") { authResult, error in
            if let error = error {
                print("\(error)")
            }
            if let result = authResult {
                print("auth :, \(result)")
                Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text ?? "") { error in
                    if let err = error {
                        print("there was an error resetting your password")
                    } else {
                        print("the user should be created and an email should be sent")
                    }
                }
            }
        }


    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
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
