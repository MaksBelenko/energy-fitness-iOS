//
//  ScheduleTabCoordinator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 14/03/2021.
//

import UIKit

final class ScheduleTabCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navController: UINavigationController
    
    private let viewControllerProvider: ViewControllerProvider
    
    init(
        viewControllerProvider: ViewControllerProvider
    ) {
        self.navController = UINavigationController()
        self.viewControllerProvider = viewControllerProvider
        start()
    }
    
    func start() {
        let scheduleVC = viewControllerProvider.createScheduleVC()
        scheduleVC.tabBarItem.image = UIImage(systemName: "calendar")
        scheduleVC.coordinator = self
        navController.setNavigationBarHidden(true, animated: false)
        navController.pushViewController(scheduleVC, animated: true)
    }
    
    func showBookSession(for session: GymSessionDto) {
        let bookSessionVC = viewControllerProvider.createBookSessionVC()
        bookSessionVC.coordinator = self
        bookSessionVC.hidesBottomBarWhenPushed = true
        bookSessionVC.setGymSessionToShow(to: session)
        navController.pushViewController(bookSessionVC, animated: true)
    }
    
    func showBookForm() {
        let bookFormVC = viewControllerProvider.createBookFormVC()
        bookFormVC.hidesBottomBarWhenPushed = true
        navController.pushViewController(bookFormVC, animated: true)
    }
    
    
    func goBack() {
        navController.popViewController(animated: true)
    }
    
    
}
