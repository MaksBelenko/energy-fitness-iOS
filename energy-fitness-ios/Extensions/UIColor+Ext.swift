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

// MARK: - Colour adjustments extension
extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}


//MARK: - Custom App Colours
extension UIColor {
    
    static private let customLightGrey = UIColor(rgb: 0xF1F1F1)
    static private let customDarkGrey = UIColor(rgb: 0x212121)
    static private let customOrangeLight = UIColor(rgb: 0xF48758)//e68c62
    static private let customOrangeDark = UIColor(rgb: 0xD36E4A)
    static private let customTextGreyLight = UIColor(rgb: 0x9A9A9A)
    static private let customTextGreyDark = UIColor(rgb: 0x7C7C7C)
    static private let customContainerDark = UIColor(rgb: 0x0F0F0F)
    static private let customCellLightGray = UIColor(rgb: 0xF1F1F1)
    static private let customCellDarkGray = UIColor(rgb: 0x1C1C1C)
    static private let customShimmerLight = UIColor(rgb: 0xD6D6D6)
    static private let customShimmerDark = UIColor(rgb: 0x2F2F2F)
    static private let customParagraphTextLight = UIColor(rgb: 0x808080)
    static private let customParagraphTextDark = UIColor(rgb: 0x909090)
    
    static private let customCardDark = UIColor(rgb: 0x171717)
    static private let customCardHandleDark = UIColor(rgb: 0x333333)
    
    static let energyGradientRedLeft = UIColor(rgb: 0x9D1014)
    static let energyGradientRedRight = UIColor(rgb: 0xE52D27)
    
    static let energyWhiteBlack = UIColor.dynamic(light: .white, dark: .black)
    
    /* Schedule colours */
    static let energyBackgroundColor = UIColor.dynamic(light: .customLightGrey, dark: .black)
    static let energyContainerColor = UIColor.dynamic(light: .white, dark: .customContainerDark)
    static let energyOrange = UIColor.dynamic(light: .customOrangeLight, dark: .customOrangeDark)
    static let energyCalendarDateColour = UIColor.dynamic(light: .black, dark: .white)
    static let energyDateDarkened = UIColor.dynamic(light: .customTextGreyLight, dark: .customTextGreyDark)
    static let energyScheduleTrainerName = UIColor.dynamic(light: .customTextGreyLight, dark: .customTextGreyDark)
    static let energyCellColour = UIColor.dynamic(light: .customCellLightGray, dark: .customCellDarkGray)
    static let energyParagraphColor = UIColor.dynamic(light: customParagraphTextLight, dark: customParagraphTextDark)
    
    /* Shimmer colours */
    static let energyShimmerUnder = UIColor.dynamic(light: .customCellLightGray, dark: .customCellDarkGray)
    static let energyShimmer = UIColor.dynamic(light: .customShimmerLight, dark: .customShimmerDark)
    
    /* Card colour */
    static let energyCard = UIColor.dynamic(light: .white, dark: .customCardDark)
    static let energyCardHandle = UIColor.dynamic(light: .white, dark: .customCardHandleDark)

    /* BookForm colours */
    static private let customTextFieldBackgroundLight = UIColor(rgb: 0xF1F1F1)
    static private let customTextFieldBackgroundDark = UIColor(rgb: 0x212121)
    static private let customTextFieldTextLight = UIColor(rgb: 0x1F1F1F)
    static private let customTextFieldTextDark = UIColor(rgb: 0xD1D1D1)
    static private let customTextFieldPlaceholderLight = UIColor(rgb: 0x6F6F6F)
    static private let customTextFieldPlaceholderDark = UIColor(rgb: 0x919191)
    static private let customTextFieldWarning = UIColor(rgb: 0xFF5353)
    
    static let energyBookFormBackground = UIColor.dynamic(light: .white, dark: .black)
    static let energyBookFormOuter = UIColor.dynamic(light: .black, dark: .white)
    static let energyTextFieldBackground = UIColor.dynamic(light: .customTextFieldBackgroundLight, dark: .customTextFieldBackgroundDark)
    static let energyTFPlaceholderColour = UIColor.dynamic(light: .customTextFieldPlaceholderLight, dark: .customTextFieldPlaceholderDark)
    static let energyTextFieldTextColour = UIColor.dynamic(light: .customTextFieldTextLight, dark: .customTextFieldTextDark)

    
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
