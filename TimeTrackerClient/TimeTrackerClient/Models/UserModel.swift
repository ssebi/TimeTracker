//
//  UserModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 14.10.2021.
//

struct User {
    var uid: String
    var email: String?
    var username: String?
    
    init(uid: String, email: String?, username: String?){
        self.uid = uid
        self.email = email
        self.username = username
    }
}
