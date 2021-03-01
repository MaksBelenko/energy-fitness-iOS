//
//  ShimmerView.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 25/02/2021.
//

import UIKit

class ShimmerView: UIView {
    
    private let shimmerCycleDuration: TimeInterval = 1.5 //sec
    
    private let gradientColour: UIColor
    private let gradientFrame: CGRect
    private let rectCornerRadius: CGFloat = 3
    
    lazy var shimmerAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")//#keyPath(CAGradientLayer.locations))
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        animation.fromValue = -gradientFrame.width
        animation.toValue = gradientFrame.width/2
        animation.duration = shimmerCycleDuration
        // sync the times for all cells
        let ct = CACurrentMediaTime().truncatingRemainder(dividingBy: shimmerCycleDuration * 2)
        animation.timeOffset = ct
        
        return animation
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradLayer = CAGradientLayer()
        gradLayer.frame = gradientFrame
        gradLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradLayer.colors = [UIColor.clear.cgColor, gradientColour.cgColor, UIColor.clear.cgColor]
        gradLayer.locations = [0.0, 0.5, 1.0]

        return gradLayer
    }()
    
    
    // MARK: - Init
    init(
        gradientColour: UIColor = .energyShimmerUnder,
        gradientFrame: CGRect
    ) {
        self.gradientColour = gradientColour
        self.gradientFrame = gradientFrame
        super.init(frame: .zero)
        
        self.layer.cornerRadius = rectCornerRadius
        self.layer.masksToBounds = true
        
        addTopBox(for: self)
        startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public methods
    func removeAnimation() {
        gradientLayer.removeAnimation(forKey: shimmerAnimation.keyPath!)
    }
    
    func startAnimation() {
        gradientLayer.add(shimmerAnimation, forKey: shimmerAnimation.keyPath!)
    }
    
    func stopAndHide() {
        removeAnimation()
        self.isHidden = true
    }
    
    func showAndResume() {
        let alreadyAnimated = self.layer.animationKeys()?.isEmpty ?? true
        if alreadyAnimated == false {
            self.isHidden = false
            startAnimation()
        }
    }
    
    
    // MARK: - Private methods
    private func addTopBox(for bottomView: UIView) {
        let view = UIView()
        view.backgroundColor = gradientColour
        addSubview(view)
        view.contain(in: bottomView)
        
        addShimmerMask(to: view)
    }


    private func addShimmerMask(to view: UIView) {
        view.layer.addSublayer(gradientLayer)
        view.layer.mask = gradientLayer
    }
}
