//
//  ButtonAnimations.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 19/02/2021.
//

import UIKit

class ButtonAnimations {
    
    func startAnimatingPressActions(for button: UIButton) {
        button.addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        button.addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        
        //Action when button is actualy pressed
//        button.addTarget(self, action: #selector(ViewController.addButtonPressed), for: .touchUpInside)
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.85, y: 0.85))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.1,  animations: {
                            button.transform = transform
                        }, completion: nil)
    }
}
