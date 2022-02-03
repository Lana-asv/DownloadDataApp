//
//  SceneDelegate.swift
//  DownloadDataApp
//
//  Created by Sveta on 09.12.2021.
//


import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let scene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: scene)
            let mainView = Assembly.buildViewController()
            self.window?.rootViewController = mainView
            self.window?.makeKeyAndVisible()
        }
    }
}
