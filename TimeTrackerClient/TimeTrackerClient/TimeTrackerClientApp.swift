//
//  TimeTrackerClientApp.swift
//  TimeTrackerClient
//
//  Created by Sebastian Vidrea on 11.10.2021.
//

import SwiftUI
import Firebase

@main
struct TimeTrackerClientApp: App {

	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	@StateObject var sessionStore = SessionStore()
	@StateObject var dataStore = DataStore()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(sessionStore)
				.environmentObject(dataStore)
		}
	}

	class AppDelegate: NSObject, UIApplicationDelegate {
		func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

			FirebaseApp.configure()

			return true
		}
	}
}
