//
//  CALayer+Ext.swift
//  energy-fitness-ios
//
//  Created by Maksim on 04/02/2021.
//

import UIKit

//MARK: - Extension for shadow effect
extension CALayer {
    func applyShadow(rect: CGRect, cornerRadius: CGFloat, color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4) {
        shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath //UIBezierPath(rect: rect).cgPath
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
    
    func removeShadow() {
        shadowOpacity = 0
    }
}

extension UICollectionViewCell {
//    func applyShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4) {
//        layer.applyShadow(color: color, alpha: alpha, x: x, y: y, blur: blur)
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
//    }
//
//    func cornerRadius(_ value: CGFloat) {
//        layer.cornerRadius = value
//
//        contentView.layer.cornerRadius = value
//        contentView.layer.borderWidth = 1.0
//
//        contentView.layer.borderColor = UIColor.clear.cgColor
//        contentView.layer.masksToBounds = true
//    }
}
