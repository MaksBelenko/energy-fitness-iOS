//
//  LoadingIndicatorView.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 18/03/2021.
//

import UIKit

class LoadingIndicatorView: UIView {
    
    var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                self.animateStroke()
                self.animateRotation()
            } else {
//                UIView.animate(withDuration: 1) { [weak self] in
//                    self?.alpha = 0
//                } completion: { [weak self] _ in
                    shapeLayer.removeFromSuperlayer()
                    layer.removeAllAnimations()
//                }
            }
        }
    }
    
    private let colours: [UIColor]
    private let lineWidth: CGFloat
    
    private lazy var shapeLayer: IndicatorShapeLayer = {
        return IndicatorShapeLayer(strokeColor: colours.first!, lineWidth: lineWidth)
    }()
    
    
    
    // MARK: - Initialization
    init(frame: CGRect, colours: [UIColor], lineWidth: CGFloat) {
        self.colours = colours
        self.lineWidth = lineWidth
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    convenience init(colours: [UIColor] = [.systemRed, .systemPurple, .systemGreen, .systemBlue], lineWidth: CGFloat = 5) {
        self.init(frame: .zero, colours: colours, lineWidth: lineWidth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let sizeRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width)
        let path = UIBezierPath(ovalIn: sizeRect)
        
        shapeLayer.path = path.cgPath
    }
    
    // MARK: - Animations
    func animateStroke() {
        
        let startAnimation = StrokeAnimation(type: .start,
                                             beginTime: 0.25,
                                             fromValue: 0.0,
                                             toValue: 1.0,
                                             duration: 0.75)
        
        let endAnimation = StrokeAnimation(type: .end,
                                           fromValue: 0.0,
                                           toValue: 1.0,
                                           duration: 0.75)
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1
        strokeAnimationGroup.repeatDuration = .infinity
        strokeAnimationGroup.animations = [startAnimation, endAnimation]
        
        shapeLayer.add(strokeAnimationGroup, forKey: nil)
        
        let colorAnimation = StrokeColourAnimation(colours: colours.map { $0.cgColor },
                                                   duration: strokeAnimationGroup.duration * Double(colours.count))

        shapeLayer.add(colorAnimation, forKey: nil)
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func animateRotation() {
        let rotationAnimation = RotationAnimation(direction: .zAxis,
                                                  fromValue: 0,
                                                  toValue: CGFloat.pi * 2,
                                                  duration: 2,
                                                  repeatCount: .greatestFiniteMagnitude)
        
        self.layer.add(rotationAnimation, forKey: nil)
    }
    
}
