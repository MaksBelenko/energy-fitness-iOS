//
//  Coordinator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 14/03/2021.
//

import UIKit

protocol CoordinatorType: AnyObject {
    var childCoordinators: [CoordinatorType] { get set }
    var navController: UINavigationController { get set }
    
    func start()
}

protocol ParentCoordinatorType: CoordinatorType {
    func childDidFinish(_ child: CoordinatorType?)
}

extension ParentCoordinatorType {
    func childDidFinish(_ child: CoordinatorType?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if child === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
