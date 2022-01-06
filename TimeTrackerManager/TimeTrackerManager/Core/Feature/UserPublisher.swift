//
//  FirebaseAddUser.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 06.01.2022.
//

import Foundation
import Firebase

class UserPublisher {
    
    public init(){

    }

    public func addUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("\(error)")
            }
            if let result = authResult {
                print("auth :, \(result)")
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let err = error {
                        print("there was an error resetting your password")
                    } else {
                        print("the user should be created and an email should be sent")
                    }
                }
            }
        }
    }
}
