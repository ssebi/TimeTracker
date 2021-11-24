//
//  DataStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation
import Firebase

class DataStore: ObservableObject {
	private let userLoader: UserLoader

	init(userLoader: UserLoader = FirebaseUserLoader()) {
		self.userLoader = userLoader
	}

	func getUser() -> User {
		userLoader.getUser()
	}
}
