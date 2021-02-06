//
//  TestingSceneDelegate.swift
//  UnitTests
//
//  Created by Maksim on 06/02/2021.
//

import UIKit

class TestingSceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let bundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "TestingMode", bundle: bundle) // Main is the name of storyboard
        window = UIWindow(windowScene: scene)
        window?.rootViewController = storyboard.instantiateInitialViewController()
        window?.makeKeyAndVisible()
    }
}
