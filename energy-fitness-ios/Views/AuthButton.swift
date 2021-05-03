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
    
    var textFont: UIFont = .raleway(ofSize: 18) {
        didSet { titleLabel?.font = textFont }
    }

    var isActive: Bool = false {
        didSet { changeAppearance(isActive) }
    }
    
    var isLoading: Bool = false {
        didSet { setLoadingStatus(to: isLoading) }
    }
    
    
    private let buttonAnimations = ButtonAnimations()
    
    private let activeColours = [UIColor.energyGradientRedLeft.cgColor, UIColor.energyGradientRedRight.cgColor]
    private let disabledColours = [UIColor.lightGray.cgColor, UIColor.lightGray.cgColor]
    private let disabledOpacity: CGFloat = 0.9
    
    private lazy var backgroundGradient: CAGradientLayer = {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = disabledColours
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        return gradient
    }()
    
    private lazy var loadingIndicator: LoadingIndicatorView = {
        let view = LoadingIndicatorView(lineWidth: 3)
        view.isAnimating = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    
    // MARK: - Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        layer.cornerRadius = 5
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        clipsToBounds = true
        layer.insertSublayer(backgroundGradient, at: 0)
        
        addSubview(loadingIndicator)
        loadingIndicator.centerX(withView: self)
        loadingIndicator.centerY(withView: self)
        loadingIndicator.anchor(width: 25, height: 25)
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
        alpha = isActive ? 1 : disabledOpacity
        let textColour = isActive ? UIColor.white : UIColor(white: 1, alpha: 0.5)
        setTitleColor(textColour, for: .normal)
        
        isUserInteractionEnabled = isActive && !isLoading
        
        if isActive {
            buttonAnimations.startAnimatingPressActions(for: self)
        } else {
            buttonAnimations.stopAnimating(for: self)
        }
    }
    
    private func setLoadingStatus(to isLoading: Bool) {
        loadingIndicator.isAnimating = isLoading
        self.titleLabel?.alpha = isLoading ? 0 : 1
        isUserInteractionEnabled = !isLoading
    }
}
