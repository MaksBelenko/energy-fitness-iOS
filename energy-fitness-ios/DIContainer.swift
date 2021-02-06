//
//  DIContainer.swift
//  energy-fitness-ios
//
//  Created by Maksim on 06/02/2021.
//

import UIKit
import Swinject

class DIContainer {
    
    func setupContainer(using container: Container) {
        
        container.register(MainTabControllerProtocol.self) { resolver -> MainTabControllerProtocol in
            let vc1 = resolver.resolve(ScheduleViewController.self)!
            return MainTabBarController.create(viewControllers: [vc1])
        }
//        .inObjectScope(.container)
        
        container.register(ScheduleViewController.self) { resolver -> ScheduleViewController in
            let vc = ScheduleViewController()
            vc.tabBarItem.image = UIImage(systemName: "calendar")
            return vc
        }
        
    }
}
