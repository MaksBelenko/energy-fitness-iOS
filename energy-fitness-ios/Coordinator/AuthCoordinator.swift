//
//  AuthCoordinator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 03/04/2021.
//

import UIKit

final class AuthCoordinator: Coordinator {
    weak var parentCoordinator: ParentCoordinator?
    
    var childCoordinators: [Coordinator] = []
    var navController: UINavigationController
    
    private let viewControllerProvider: ViewControllerProvider
    
    init(
        viewControllerProvider: ViewControllerProvider
    ) {
        self.navController = UINavigationController()
        self.viewControllerProvider = viewControllerProvider
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
