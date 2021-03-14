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
    
    private let scheduleVC: ScheduleViewController
    private let bookSessionVC: BookSessionViewController
    
    init(
        scheduleVC: ScheduleViewController,
        bookSessionVC: BookSessionViewController
    ) {
        self.navController = UINavigationController()
        self.scheduleVC = scheduleVC
        self.bookSessionVC = bookSessionVC
        start()
    }
    
    func start() {
        scheduleVC.tabBarItem.image = UIImage(systemName: "calendar")
        scheduleVC.coordinator = self
        navController.setNavigationBarHidden(true, animated: false)
        navController.pushViewController(scheduleVC, animated: true)
    }
    
    func showBookClass() {
        navController.pushViewController(bookSessionVC, animated: true)
    }
    
    
}
