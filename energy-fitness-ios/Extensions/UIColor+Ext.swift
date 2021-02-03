//
//  UIColor+Ext.swift
//  energy-fitness-ios
//
//  Created by Maksim on 02/02/2021.
//

import UIKit



//MARK: - Extension for UIColor hex color representation
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}


//MARK: - Custom App Colours
extension UIColor {
    
    static let customLightGray = UIColor(rgb: 0xEFEFEF)
    static let customOrange = UIColor(rgb: 0xEF7D54)
    static let customTextGreyLight = UIColor(rgb: 0x9A9A9A)
    static let customTextGreyDark = UIColor(rgb: 0x7C7C7C)
    static let customContainerDark = UIColor(rgb: 0x0F0F0F)
    
    static let energyBackgroundColor = UIColor.dynamic(light: .customLightGray, dark: .black)
    static let energyContainerColor = UIColor.dynamic(light: .white, dark: .customContainerDark)
    static let energyOrange = UIColor.dynamic(light: .customOrange, dark: .customOrange)
    static let energyCalendarDateColour = UIColor.dynamic(light: .black, dark: .white)
    static let energyDateDarkened = UIColor.dynamic(light: .customTextGreyDark, dark: .customTextGreyDark)
    
    
    static let customBlue = UIColor(rgb: 0x0075EB)
    static let lightRed = UIColor(rgb: 0xFF6060)
    static let lightGreen = UIColor(rgb: 0x27AE60)
    static let superLightGray = UIColor(rgb: 0xEEEEEE).withAlphaComponent(0.8)
    
    
    
    
    static let cellSelectionColor = UIColor.dynamic(light: .superLightGray, dark: .darkGray)

    
    static func dynamic(light: UIColor, dark: UIColor) -> UIColor {

        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: {
                switch $0.userInterfaceStyle {
                case .dark:
                    return dark
                case .light, .unspecified:
                    return light
                @unknown default:
                    assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                    return light
                }
            })
        }

        // iOS 12 and earlier
        return light
    }
}
