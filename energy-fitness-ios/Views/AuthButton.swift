//
//  AuthButton.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/03/2021.
//

import UIKit

class AuthButton: UIButton {
    
    var title: String = " " {
        didSet { setTitle(title, for: .normal) }
    }

    var isActive: Bool = false {
        didSet { changeAppearance(isActive) }
    }
    
    
    private let buttonAnimations = ButtonAnimations()
    
    private let activeColours = [UIColor.energyGradientRedLeft.cgColor, UIColor.energyGradientRedRight.cgColor]
    private let disabledColours = [UIColor.lightGray.cgColor, UIColor.lightGray.cgColor]
    
    private lazy var backgroundGradient: CAGradientLayer = {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = disabledColours
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        return gradient
    }()
    
    
    // MARK: - Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        layer.cornerRadius = 5
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        clipsToBounds = true
        layer.insertSublayer(backgroundGradient, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradient.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Private methods
    private func changeAppearance(_ isActive: Bool) {
        backgroundGradient.colors = isActive ? activeColours : disabledColours
        let textColour = isActive ? UIColor.white : UIColor(white: 1, alpha: 0.5)
        setTitleColor(textColour, for: .normal)
        
        if isActive {
            buttonAnimations.startAnimatingPressActions(for: self)
        } else {
            buttonAnimations.stopAnimating(for: self)
        }
    }
}
