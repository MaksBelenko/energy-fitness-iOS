//
//  AccountSettingsCoordinator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 26/06/2021.
//

import UIKit

final class AccountSettingsCoordinator: CoordinatorType {
    weak var parentCoordinator: ParentCoordinatorType?
    
    var childCoordinators: [CoordinatorType] = []
    lazy var navController = UINavigationController()
    
    private let viewControllerProvider: ViewControllerProvider
    
    init(viewControllerProvider: ViewControllerProvider) {
        self.viewControllerProvider = viewControllerProvider
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    func start() {
        let accountVC = AccountViewController()
        accountVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        navController.pushViewController(accountVC, animated: false)
//        let scheduleVC = viewControllerProvider.createScheduleVC()
//        scheduleVC.tabBarItem.image = UIImage(systemName: "calendar")
//        scheduleVC.coordinator = self
//        navController.setNavigationBarHidden(true, animated: false)
//        navController.pushViewController(scheduleVC, animated: true)
    }
    
}
    
