//
//  AppCoordinator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 18/04/2021.
//

import UIKit
import Combine

final class AppCoordinator: ParentCoordinatorType {
    var childCoordinators: [CoordinatorType] = []
    lazy var navController = UINavigationController()
    
    
    private var subscriptions = Set<AnyCancellable>()
    private let viewControllerProvider: ViewControllerProvider
    private let networkManager: NetworkManager
    private var authCoordinator: AuthCoordinator?
    
    private var scheduleCoordinator: ScheduleTabCoordinator?
    
    init(
        viewControllerProvider: ViewControllerProvider,
        networkManager: NetworkManager
    ) {
        self.viewControllerProvider = viewControllerProvider
        self.networkManager = networkManager
//        setupAuthListener()
    }
    
    func start() {
        let tabController = MainTabBarController()
        scheduleCoordinator = ScheduleTabCoordinator(viewControllerProvider: viewControllerProvider)
        scheduleCoordinator!.start()
        
        tabController.viewControllers = [scheduleCoordinator!.navController]
        
        navController.setNavigationBarHidden(true, animated: false)
        navController.pushViewController(tabController, animated: false)
    }
    
    
    private func setupAuthListener() {
        networkManager.isSignedIn()
            .print("TTT: AppDelegate signin")
            .sink { [unowned self] isSignedIn in
                if isSignedIn == false {
                    self.showAuth()
                } else {
                    self.dismissAuth()
                }
            }
            .store(in: &subscriptions)
    }
    
    
    private func showAuth() {
        authCoordinator = AuthCoordinator(viewControllerProvider: viewControllerProvider)
        authCoordinator!.parentCoordinator = self
        authCoordinator!.start()
        
        navController.present(authCoordinator!.navController, animated: true, completion: nil)
        childCoordinators.append(authCoordinator!)
    }
    
    private func dismissAuth() {
        authCoordinator?.dismissAuth()
        authCoordinator = nil
    }
}
