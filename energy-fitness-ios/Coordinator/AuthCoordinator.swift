//
//  AuthCoordinator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 03/04/2021.
//

import UIKit

final class AuthCoordinator: CoordinatorType {
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
        navController.modalPresentationStyle = .overFullScreen
        
        let loginVC = viewControllerProvider.createLoginVC()
        navController.setNavigationBarHidden(true, animated: false)
        navController.pushViewController(loginVC, animated: false)
    }
    
    func showRegisterVC() {}
    
    
    
    func dismissAuth() {
        parentCoordinator?.childDidFinish(self)
        navController.dismiss(animated: true, completion: nil)
    }
}
