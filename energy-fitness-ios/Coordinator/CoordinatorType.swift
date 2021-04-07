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

protocol ParentCoordinator: CoordinatorType {
    func childDidFinish(_ child: CoordinatorType?)
}
