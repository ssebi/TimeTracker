//
//  UserModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 14.10.2021.
//

import Combine

class User: ObservableObject {
    @Published var uid: String?
    @Published var email: String?
    @Published var username: String?
    @Published var client: String?
    
    init(uid: String?, email: String?, username: String?, client: String?) {
        self.uid = uid
        self.email = email
        self.username = username
        self.client = client
    }
}
