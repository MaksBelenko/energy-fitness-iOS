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
    static let customOrangeLight = UIColor(rgb: 0xEF7D54)
    static let customOrangeDark = UIColor(rgb: 0xD36E4A)
    static let customTextGreyLight = UIColor(rgb: 0x9A9A9A)
    static let customTextGreyDark = UIColor(rgb: 0x7C7C7C)
    static let customContainerDark = UIColor(rgb: 0x0F0F0F)
    static let customCellLightGray = UIColor(rgb: 0xEFEFEF)
    static let customCellDarkGray = UIColor(rgb: 0x1C1C1C)
    static let customShimmerLight = UIColor(rgb: 0xD6D6D6)
    static let customShimmerDark = UIColor(rgb: 0x2F2F2F)
    static let customParagraphTextLight = UIColor(rgb: 0x808080)
    static let customParagraphTextDark = UIColor(rgb: 0x909090)
    
    
    static let energyBackgroundColor = UIColor.dynamic(light: .customLightGray, dark: .black)
    static let energyContainerColor = UIColor.dynamic(light: .white, dark: .customContainerDark)
    static let energyOrange = UIColor.dynamic(light: .customOrangeLight, dark: .customOrangeDark)
    static let energyCalendarDateColour = UIColor.dynamic(light: .black, dark: .white)
    static let energyDateDarkened = UIColor.dynamic(light: .customTextGreyLight, dark: .customTextGreyDark)
    static let energyScheduleTrainerName = UIColor.dynamic(light: .customTextGreyLight, dark: .customTextGreyDark)
    static let energyCellColour = UIColor.dynamic(light: .customCellLightGray, dark: .customCellDarkGray)
    
    static let energyShimmerUnder = UIColor.dynamic(light: .customCellLightGray, dark: .customCellDarkGray)
    static let energyShimmer = UIColor.dynamic(light: .customShimmerLight, dark: .customShimmerDark)
    
    static let energyParagraphColor = UIColor.dynamic(light: customParagraphTextLight, dark: customParagraphTextDark)
    
    
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
