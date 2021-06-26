//
//  SlideTransitionAnimator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 26/06/2021.
//

import Foundation
import UIKit

class SlideTransitionAnimator: NSObject {
    
    private let duration: TimeInterval
    private var operation: UINavigationController.Operation = .push
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func setOperation(to operation: UINavigationController.Operation) {
        self.operation = operation
    }
}


extension SlideTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
    }
    
}
