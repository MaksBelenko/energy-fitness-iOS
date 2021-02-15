//
//  MainTabBarController.swift
//  energy-fitness-ios
//
//  Created by Maksim on 02/02/2021.
//

import UIKit
import SwiftUI

protocol MainTabControllerProtocol: UIViewController {
}

class MainTabBarController: UITabBarController, MainTabControllerProtocol {
    
    static func create(viewControllers: [UIViewController]) -> MainTabBarController {
        let tabBarController = MainTabBarController()
        tabBarController.viewControllers = viewControllers

        return tabBarController
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()

//        tabBar.layer.cornerRadius = 15
//        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        tabBar.layer.masksToBounds = true
        
    }
    
    // MARK: - Configuration

    private func configureTabBar() {
        UITabBar.appearance().barTintColor = .energyBackgroundColor
        UITabBar.appearance().tintColor = .energyOrange
        // remove tabbar separator line
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
}


// MARK: - UITabBarControllerDelegate Extension
extension MainTabBarController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//    }
}


// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------
struct MainTabBar_TestIntegratedController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let container = DIContainer.staticContainerSwiftUIPreviews
        let vc1 = container.resolve(ScheduleViewController.self)!
        vc1.tabBarItem.image = UIImage(systemName: "calendar")
        
        return MainTabBarController.create(viewControllers: [vc1])
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct MainTabBar_TestPreviewController: View {
    var body: some View {
        MainTabBar_TestIntegratedController()
            .edgesIgnoringSafeArea(.all)
    }
}

struct MainTabBar_TestPreviewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainTabBar_TestPreviewController()
                .preferredColorScheme(.light)
    //            .previewDevice("iPhone 7")
            
            MainTabBar_TestPreviewController()
                .preferredColorScheme(.dark)
        }
    }
}
