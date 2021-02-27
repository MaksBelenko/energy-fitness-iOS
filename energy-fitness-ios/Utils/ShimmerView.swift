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




//extension UIView {
//
//    // ->1
//    enum Direction: Int {
//        case topToBottom = 0
//        case bottomToTop
//        case leftToRight
//        case rightToLeft
//    }
//
//    func startShimmeringAnimation(animationSpeed: Float = 1.4,
//                                  direction: Direction = .leftToRight,
//                                  repeatCount: Float = MAXFLOAT) {
//
//        // Create color  ->2
//        let lightColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
//        let blackColor = UIColor.black.cgColor
//
//        // Create a CAGradientLayer  ->3
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [blackColor, lightColor, blackColor]
//        gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
//
//        switch direction {
//        case .topToBottom:
//            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
//
//        case .bottomToTop:
//            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
//            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
//
//        case .leftToRight:
//            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//
//        case .rightToLeft:
//            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
//        }
//
//        gradientLayer.locations =  [0.35, 0.50, 0.65] //[0.4, 0.6]
//        self.layer.mask = gradientLayer
//
//        // Add animation over gradient Layer  ->4
//        CATransaction.begin()
//        let animation = CABasicAnimation(keyPath: "locations")
//        animation.fromValue = [0.0, 0.1, 0.2]
//        animation.toValue = [0.8, 0.9, 1.0]
//        animation.duration = CFTimeInterval(animationSpeed)
//        animation.repeatCount = repeatCount
//        CATransaction.setCompletionBlock { [weak self] in
//            guard let strongSelf = self else { return }
//            strongSelf.layer.mask = nil
//        }
//        gradientLayer.add(animation, forKey: "shimmerAnimation")
//        CATransaction.commit()
//    }
//
//    func stopShimmeringAnimation() {
//        self.layer.mask = nil
//    }
//
//}

