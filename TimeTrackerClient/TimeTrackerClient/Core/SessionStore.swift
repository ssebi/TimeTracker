//
//  SesionStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 13.10.2021.
//

import SwiftUI
import Firebase

class SessionStore {
    
    var authError: Error?
    var authResult: AuthDataResult?
    
    func singIn( email: String, password: String ) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (error, result) in
            self.authResult = error
            self.authError = result
            
            if self.authResult != nil {
                //create user
                print(self.authError ?? "Something wrong")
            } else {
                print("success")
            }
        }
    }
    

}
