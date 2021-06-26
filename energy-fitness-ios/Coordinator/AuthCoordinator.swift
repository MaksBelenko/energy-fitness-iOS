//
//  AuthCoordinator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 03/04/2021.
//

import UIKit

final class AuthCoordinator: NSObject, CoordinatorType {
    weak var parentCoordinator: ParentCoordinatorType?
    
    var childCoordinators: [CoordinatorType] = []
    lazy var navController = UINavigationController()
    
    private let viewControllerProvider: ViewControllerProvider
    
    init(viewControllerProvider: ViewControllerProvider) {
        self.viewControllerProvider = viewControllerProvider
        super.init()

        navController.delegate = self
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    func start() {
        navController.modalPresentationStyle = .overFullScreen
        
        let loginVC = viewControllerProvider.createLoginVC()
        loginVC.coordinator = self
        navController.setNavigationBarHidden(true, animated: false)
        navController.pushViewController(loginVC, animated: false)
    }
    
    func showRegisterVC() {
        let signupVC = viewControllerProvider.createSignupVC()
        signupVC.coordinator = self
        navController.pushViewController(signupVC, animated: true)
    }
    
    
    func backToLogin() {
        navController.popViewController(animated: true)
    }
    
    
    
    func dismissAuth() {
        parentCoordinator?.childDidFinish(self)
        navController.dismiss(animated: true, completion: nil)
    }
}

extension AuthCoordinator: UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {

        return nil
        
//        if ( (toVC is CameraViewController && fromVC is ViewController) ||
//            (toVC is ViewController && fromVC is CameraViewController)) {
//
//            circularTransition.transitionMode = (operation == .push) ? .present : .pop
//            circularTransition.startingPoint = animationCentre
//            return circularTransition
//        }

//        return nil
    }
}
