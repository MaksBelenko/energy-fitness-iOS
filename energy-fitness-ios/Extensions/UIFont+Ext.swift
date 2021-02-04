//
//  UIFont+Ext.swift
//  energy-fitness-ios
//
//  Created by Maksim on 02/02/2021.
//

import UIKit.UIFont

extension UIFont {
    static func calendarDateFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.helveticaNeue(ofSize: size)
    }
    
    static func topCornerDateFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.helveticaNeue(ofSize: size)
    }
}

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
        return UIFont(name: weightFontName.rawValue, size: size)! //?? UIFont.systemFont(ofSize: size)
    }
}

// MARK: - Raleway Font
extension UIFont {
    
    enum RalewayFontWeight: String {
        case black = "Raleway-Black"
        case bold = "Raleway-Bold"
        case extraBold = "Raleway-ExtraBold"
        case extraLight = "Raleway-ExtraLight"
        case light = "Raleway-Light"
        case medium = "Raleway-Medium"
        case regular = "Raleway-Regular"
        case semiBold = "Raleway-SemiBold"
        case thin = "Raleway-Thin"
    }
    
    static func raleway(ofSize size: CGFloat, weight weightFontName: RalewayFontWeight = .regular ) -> UIFont {
        return UIFont(name: weightFontName.rawValue, size: size)! //?? UIFont.systemFont(ofSize: size)
    }
}
