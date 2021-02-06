//
//  WeekDay.swift
//  WeekCalendar
//
//  Created by Maksim on 25/10/2020.
//  Copyright © 2020 Maksim Belenko. All rights reserved.
//

import Foundation

enum WeekDayPresentation {
    case OneLetter
    case Short
    case Full
}

enum WeekDay: String, CaseIterable {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
}
 
extension WeekDay {
    
    func getNumber() -> Int {
        switch self {
        case .Sunday:
            return 1
        case .Monday:
            return 2
        case .Tuesday:
            return 3
        case .Wednesday:
            return 4
        case .Thursday:
            return 5
        case .Friday:
            return 6
        case .Saturday:
            return 7
        }
    }
    
    func getLocalisedString(format: WeekDayPresentation) -> String {
        switch format {
        case .OneLetter:
            return String(shortNameDictionary[self]!.prefix(1))
        case .Short:
            return shortNameDictionary[self]!
        case .Full:
            return fullNameDictionary[self]!
        }
    }
    
    private var shortNameDictionary: Dictionary<WeekDay, String>  {
        get { return [
            .Monday    : NSLocalizedString("Mon", comment: "Short name of week days"),
            .Tuesday   : NSLocalizedString("Tue", comment: "Short name of week days"),
            .Wednesday : NSLocalizedString("Wed", comment: "Short name of week days"),
            .Thursday  : NSLocalizedString("Thu", comment: "Short name of week days"),
            .Friday    : NSLocalizedString("Fri", comment: "Short name of week days"),
            .Saturday  : NSLocalizedString("Sat", comment: "Short name of week days"),
            .Sunday    : NSLocalizedString("Sun", comment: "Short name of week days")
        ]}
    }
    
    private var fullNameDictionary: Dictionary<WeekDay, String>  {
        get { return [
            .Monday    : NSLocalizedString("Monday",    comment: "Names of week days"),
            .Tuesday   : NSLocalizedString("Tuesday",   comment: "Names of week days"),
            .Wednesday : NSLocalizedString("Wednesday", comment: "Names of week days"),
            .Thursday  : NSLocalizedString("Thursday",  comment: "Names of week days"),
            .Friday    : NSLocalizedString("Friday",    comment: "Names of week days"),
            .Saturday  : NSLocalizedString("Saturday",  comment: "Names of week days"),
            .Sunday    : NSLocalizedString("Sunday",    comment: "Names of week days")
        ]}
    }
}
