//
//  SceneDelegate.swift
//  TimeTrackerManager
//
//  Created by Sebastian Vidrea on 09.12.2021.
//

import UIKit
import TimeTrackerAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
    let session = SessionStore(authProvider: FirebaseAuthProvider())

	func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
		guard (scene as? UIWindowScene) != nil else { return }
        if self.session.user == nil {
            window?.rootViewController = UIStoryboard(
                name: "Main",
                bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            window?.makeKeyAndVisible()
        } else {
            window?.rootViewController = UIStoryboard(
                name: "Main",
                bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
            window?.makeKeyAndVisible()
        }
	}
}
