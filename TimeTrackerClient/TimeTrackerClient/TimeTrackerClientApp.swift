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
	@StateObject var sessionStore = SessionStore(authProvider: FirebaseAuthProvider())

	private var clientsStore: ClientsStore = {
		FirebaseClientsStore()
	}()
	private var timeslotsStore: TimeslotsStore = {
		FirebaseTimeslotsStore()
	}()
	private var userLoader: FirebaseUserLoader = {
		FirebaseUserLoader()
	}()
	
	private var remoteTimeslotsLoader: TimeslotsLoader {
		RemoteTimeslotsLoader(store: timeslotsStore)
	}
	private var remoteClientsLoader: ClientsLoader {
		RemoteClientsLoader(store: clientsStore)
	}
	private var remoteTimeslotsPublisher: TimeSlotsPublisher {
		RemoteTimeSlotsPublisher(store: timeslotsStore)
	}
	
	var body: some Scene {
		WindowGroup {
			Group {
				if sessionStore.user != nil {
					HomeScreenUIComposer.makeHomeScreen(timeslotsLoader: remoteTimeslotsLoader, userLoader: userLoader, addView: {
						AddScreenUIComposer.makeAddScreen(clientsLoader: remoteClientsLoader, timeslotsPublisher: remoteTimeslotsPublisher, userLoader: userLoader)
					})
				} else {
                    LoginView(viewModel: LoginViewModel(session: sessionStore))
				}
			}
			.environmentObject(sessionStore)
		}
	}

	class AppDelegate: NSObject, UIApplicationDelegate {
		func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
			FirebaseApp.configure()
			return true
		}
	}

}
