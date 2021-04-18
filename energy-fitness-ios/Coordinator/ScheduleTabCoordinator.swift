//
//  ScheduleTabCoordinator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 14/03/2021.
//

import UIKit
import Combine

final class ScheduleTabCoordinator: ParentCoordinator {
    weak var parentCoordinator: ParentCoordinator?
    
    var childCoordinators: [CoordinatorType] = []
    lazy var navController = UINavigationController()
    
    private let viewControllerProvider: ViewControllerProvider
    
    init(
        viewControllerProvider: ViewControllerProvider
    ) {
        self.viewControllerProvider = viewControllerProvider
    }
    
    deinit {
        Log.logDeinit("\(self)")
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
    
    
    func showSortCard<T: Hashable>(title: String, items: [CardFilterItem<T>]) -> AnyPublisher<T, Never> {
        let filterView = FilterCardView(title: title, items: items)
        let cardVC = CardViewController(innerView: filterView)
        cardVC.cardHeight = 250
        cardVC.modalPresentationStyle = .overFullScreen
        navController.present(cardVC, animated: false, completion: nil)
        
        return filterView.selectedSubject
            .eraseToAnyPublisher()
    }
}
