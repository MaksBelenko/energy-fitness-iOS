//
//  ScheduleTabCoordinator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 14/03/2021.
//

import UIKit
import Combine

final class ScheduleTabCoordinator: ParentCoordinatorType {
    weak var parentCoordinator: ParentCoordinatorType?
    
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
    
    
    func showSortCard() -> AnyPublisher<ScheduleSortType, Never> {
        let sortOptions: [CardFilterItem<ScheduleSortType>] = [.init(value: .time, image: UIImage(named: "icon-clock")!, filterName: NSLocalizedString("time_sort", comment: "Card sort option")),
                                                               .init(value: .trainer, image: UIImage(named: "icon-trainer")!, filterName: NSLocalizedString("trainer_name_sort", comment: "Card sort option")),
                                                               .init(value: .gymClass, image: UIImage(named: "icon-skipping")!, filterName: NSLocalizedString("gym_class_name_sort", comment: "Card sort option"))]
        
        let filterView = FilterCardView(title: NSLocalizedString("select_sort_option", comment: "Card sort option"),
                                        items: sortOptions)
        let cardVC = CardViewController(innerView: filterView)
        
        let window = UIApplication.shared.windows[0]
        let bottomPadding = window.safeAreaInsets.bottom
        cardVC.cardHeight = 210 + bottomPadding // adjust for safeArea
        
        cardVC.modalPresentationStyle = .overFullScreen
        navController.present(cardVC, animated: false, completion: nil)
        
        return filterView.selectedSubject
            .eraseToAnyPublisher()
    }
}
