//
//  IndicatorShapeLayer.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 18/03/2021.
//

import UIKit

class IndicatorShapeLayer: CAShapeLayer {
    
    public init(strokeColor: UIColor, lineWidth: CGFloat) {
        super.init()
        
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = lineWidth
        self.fillColor = UIColor.clear.cgColor
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
