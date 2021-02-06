//
//  Month.swift
//  WeekCalendar
//
//  Created by Maksim on 25/10/2020.
//  Copyright © 2020 Maksim Belenko. All rights reserved.
//

import UIKit


enum MonthPresentationType {
    case ThreeLetters
    case Full
}


enum Month: String, CaseIterable {
    case January
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
}


extension Month {
    
    func getLocalisedName(format: MonthPresentationType = .Full) -> String {
        switch format {
        case .Full:
            return fullNameLocalisedDictionary[self]!
        case .ThreeLetters:
            return String(fullNameLocalisedDictionary[self]!.prefix(3))
        }
    }
    
    private var fullNameLocalisedDictionary: [Month : String] {
        get { return [
            .January   : NSLocalizedString("January", comment: "Months names"),
            .February  : NSLocalizedString("February", comment: "Months names"),
            .March     : NSLocalizedString("March", comment: "Months names"),
            .April     : NSLocalizedString("April", comment: "Months names"),
            .May       : NSLocalizedString("May", comment: "Months names"),
            .June      : NSLocalizedString("June", comment: "Months names"),
            .July      : NSLocalizedString("July", comment: "Months names"),
            .August    : NSLocalizedString("August", comment: "Months names"),
            .September : NSLocalizedString("September", comment: "Months names"),
            .October   : NSLocalizedString("October", comment: "Months names"),
            .November  : NSLocalizedString("November", comment: "Months names"),
            .December  : NSLocalizedString("December", comment: "Months names"),
        ] }
    }
    
    
    func getNumber() -> Int {
        switch self {
        case .January:
            return 1
        case .February:
            return 2
        case .March:
            return 3
        case .April:
            return 4
        case .May:
            return 5
        case .June:
            return 6
        case .July:
            return 7
        case .August:
            return 8
        case .September:
            return 9
        case .October:
            return 10
        case .November:
            return 11
        case .December:
            return 12
        }
    }
}

