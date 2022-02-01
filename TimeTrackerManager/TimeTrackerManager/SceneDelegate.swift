//
//  SceneDelegate.swift
//  TimeTrackerManager
//
//  Created by Sebastian Vidrea on 09.12.2021.
//

import UIKit
import TimeTrackerAuth
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    static let session = SessionStore(authProvider: FirebaseAuthProvider())
    var subscriptions = [AnyCancellable]()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
            guard (scene as? UIWindowScene) != nil else { return }
			let sub = Self.session.$user.receive(on: RunLoop.main).sink { [weak self] user in
                if user == nil {
                    self?.window?.rootViewController = UIStoryboard(
                        name: "Main",
                        bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
                    self?.window?.makeKeyAndVisible()
                } else {
                    self?.window?.rootViewController = UIStoryboard(
                        name: "Main",
                        bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
                    self?.window?.makeKeyAndVisible()
                }
            }
            subscriptions.append(sub)
        }
}
