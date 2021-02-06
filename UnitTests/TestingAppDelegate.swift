//
//  TestingAppDelegate.swift
//  UnitTests
//
//  Created by Maksim on 06/02/2021.
//

import UIKit
@testable import EnergyFitnessApp

@objc(TestingAppDelegate)
final class TestingAppDelegate: UIResponder, UIApplicationDelegate {

//    var window: UIWindow?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//        let bundle = Bundle(for: type(of: self))
//        let storyboard = UIStoryboard(name: "TestingMode", bundle: bundle) // Main is the name of storyboard
//        window = UIWindow()
//        window?.rootViewController = storyboard.instantiateInitialViewController()
//        window?.makeKeyAndVisible()
//
//
//        return true
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Remove any cached scene configurations to ensure that TestingAppDelegate.application(_:configurationForConnecting:options:) is called and TestingSceneDelegate will be used when running unit tests. NOTE: THIS IS PRIVATE API AND MAY BREAK IN THE FUTURE!
        for sceneSession in application.openSessions {
            application.perform(Selector(("_removeSessionFromSessionSet:")), with: sceneSession)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = TestingSceneDelegate.self

        return sceneConfiguration
    }
}
