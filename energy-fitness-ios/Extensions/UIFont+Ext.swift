//
//  UIFont+Ext.swift
//  energy-fitness-ios
//
//  Created by Maksim on 02/02/2021.
//

import UIKit.UIFont

// MARK: - Helvetica Neue Font (Comes as default Font)
extension UIFont {
    
    enum HalveticaNeueWeight: String {
        case regular = "HelveticaNeue"
        case bold = "HelveticaNeue-Bold"
        case medium = "HelveticaNeue-Medium"
        case thin = "HelveticaNeue-Thin"
    }
    
    static func helveticaNeue(ofSize size: CGFloat, weight weightFontName: HalveticaNeueWeight = .regular) -> UIFont {
        return UIFont(name: weightFontName.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

// MARK: - Roboto Font
extension UIFont {
    
    enum RobotoFontWeight: String {
        case regular = "Roboto-Regular"
        case bold = "Roboto-Bold"
        case light = "Roboto-Light"
        case thin = "Roboto-Thin"
        case medium = "Roboto-Medium"
    }
    
    static func roboto(ofSize size: CGFloat, weight weightFontName: RobotoFontWeight = .regular ) -> UIFont {
        return UIFont(name: weightFontName.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
