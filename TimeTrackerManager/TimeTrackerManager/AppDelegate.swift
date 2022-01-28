//
//  AppDelegate.swift
//  TimeTrackerManager
//
//  Created by Sebastian Vidrea on 09.12.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		FirebaseApp.configure()
		return true
	}
}
