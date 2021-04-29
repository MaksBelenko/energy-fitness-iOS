//
//  StrokeColourAnimation.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 18/03/2021.
//

import UIKit

class StrokeColourAnimation: CAKeyframeAnimation {
    
    override init() {
        super.init()
    }
    
    init(colours: [CGColor], duration: Double) {
        super.init()
        
        self.keyPath = #keyPath(CAShapeLayer.strokeColor)
        self.values = colours
        self.duration = duration
        self.repeatCount = .greatestFiniteMagnitude
        self.timingFunction = .init(name: .easeInEaseOut)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
