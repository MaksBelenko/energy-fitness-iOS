//
//  Coordinator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 14/03/2021.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navController: UINavigationController { get set }
    
    func start()
}

protocol ParentCoordinator: Coordinator {
    func childDidFinish(_ child: Coordinator?)
}
