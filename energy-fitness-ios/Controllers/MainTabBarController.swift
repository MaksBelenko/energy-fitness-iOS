//
//  MainTabBarController.swift
//  energy-fitness-ios
//
//  Created by Maksim on 02/02/2021.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    
    static func create(_ viewControllers: [UIViewController]) -> MainTabBarController {
        let tabBarController = MainTabBarController()
        tabBarController.viewControllers = viewControllers
        
        return tabBarController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        configureViewControllers()
        
//        tabBar.layer.cornerRadius = 15
//        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        tabBar.layer.masksToBounds = true
        
    }

    private func configureTabBar() {
        UITabBar.appearance().barTintColor = .energyBackgroundColor
        UITabBar.appearance().tintColor = .energyOrange
        // remove tabbar separator line
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    private func configureViewControllers() {
        let vc1 = ScheduleViewController()
        vc1.tabBarItem.image = UIImage(systemName: "house")
        
        let vc2 = ScheduleViewController()
        vc2.tabBarItem.image = UIImage(systemName: "calendar")
        vc2.view.backgroundColor = .green
        
        let vc3 = ScheduleViewController()
        vc3.tabBarItem.image = UIImage(systemName: "person")
        vc3.view.backgroundColor = .blue
        
        let vc4 = ScheduleViewController()
        vc4.tabBarItem.image = UIImage(systemName: "gear")
        vc4.view.backgroundColor = .cyan
        
        self.viewControllers = [vc1, vc2, vc3, vc4]
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
        return MainTabBarController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct MainTabBar_TestPreviewController: View {
    var body: some View {
        MainTabBar_TestIntegratedController().edgesIgnoringSafeArea(.all)
    }
}

struct MainTabBar_TestPreviewController_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBar_TestPreviewController().preferredColorScheme(.light)//.previewDevice("iPhone 7")
    }
}

//struct MainTabBar_TestPreviewController_Previews2: PreviewProvider {
//    static var previews: some View {
//        MainTabBar_TestPreviewController().previewDevice("iPhone 12 mini")
//    }
//}
