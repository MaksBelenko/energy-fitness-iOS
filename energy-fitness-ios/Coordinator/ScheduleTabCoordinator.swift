//
//  ScheduleTabCoordinator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 14/03/2021.
//

import UIKit
import Combine

final class ScheduleTabCoordinator: ParentCoordinator {
    var childCoordinators: [CoordinatorType] = []
    var navController: UINavigationController
    
    private let viewControllerProvider: ViewControllerProvider
    
    init(
        viewControllerProvider: ViewControllerProvider
    ) {
        self.navController = UINavigationController()
        self.viewControllerProvider = viewControllerProvider
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
    
    
    func goBack() {
        navController.popViewController(animated: true)
    }
    
    
    func showAuth() {
        let authCoordinator = AuthCoordinator(viewControllerProvider: viewControllerProvider)
        authCoordinator.parentCoordinator = self
        authCoordinator.start()
        
        navController.present(authCoordinator.navController, animated: true, completion: nil)
        childCoordinators.append(authCoordinator)
    }
    
    func showSortCard<T: Hashable>(title: String, items: [CardFilterItem<T>]) -> AnyPublisher<T, Never> {
        let filterView = FilterCardView(title: title, items: items)
        let cardVC = CardViewController(innerView: filterView)
        cardVC.cardHeight = 250
        cardVC.modalPresentationStyle = .overFullScreen
        navController.present(cardVC, animated: false, completion: nil)
        
        return filterView.selectedSubject
            .eraseToAnyPublisher()
    }
    
    
    
    func childDidFinish(_ child: CoordinatorType?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if child === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
