//
//  SceneDelegate.swift
//  magic.world
//
//  Created by Andrew Finke on 10/5/19.
//  Copyright © 2019 Andrew Finke. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties -

    var window: UIWindow?

    // MARK: - UIWindowSceneDelegate -

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = ViewController()

            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
