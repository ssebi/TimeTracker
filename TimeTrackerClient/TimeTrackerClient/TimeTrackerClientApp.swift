//
//  TimeTrackerClientApp.swift
//  TimeTrackerClient
//
//  Created by Sebastian Vidrea on 11.10.2021.
//

import SwiftUI
import Firebase
import TimeTrackerAuth
import TimeTrackerCore

@main
struct TimeTrackerClientApp: App {

	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@StateObject var sessionStore = SessionStore(authProvider: FirebaseAuthProvider())

	private let dependencies = Dependencies()
	
	var body: some Scene {
		WindowGroup {
			Group {
				if sessionStore.user != nil {
					HomeScreenUIComposer.makeHomeScreen(timeslotsLoader: dependencies.remoteTimeslotsLoader, userLoader: dependencies.userLoader, addView: {
						dependencies.addScreen
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

// MARK: - Dependencies

extension TimeTrackerClientApp {
	fileprivate class Dependencies {
		fileprivate var clientsStore: ClientsStore = {
			FirebaseClientsStore()
		}()
		fileprivate var timeslotsStore: TimeslotsStore = {
			FirebaseTimeslotsStore()
		}()
		fileprivate var userLoader: FirebaseUserLoader = {
			FirebaseUserLoader()
		}()

		fileprivate var addScreen: AddView {
			AddScreenUIComposer.makeAddScreen(clientsLoader: remoteClientsLoader, timeslotsPublisher: remoteTimeslotsPublisher, userLoader: userLoader)
		}

		fileprivate var remoteTimeslotsLoader: TimeslotsLoader {
			RemoteTimeslotsLoader(store: timeslotsStore)
		}
		fileprivate var remoteClientsLoader: ClientsLoader {
			RemoteClientsLoader(store: clientsStore)
		}
		fileprivate var remoteTimeslotsPublisher: TimeSlotsPublisher {
			RemoteTimeSlotsPublisher(store: timeslotsStore)
		}
	}
}
