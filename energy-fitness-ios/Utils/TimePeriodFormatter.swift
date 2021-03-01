//
//  TimePeriodFormatter.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation

protocol TimePeriodFormatterProtocol {
    func getTimePeriod(from startDate: Date, durationMins: Int) -> String
    func getLocalisedStringTime(from date: Date) -> String
}

class TimePeriodFormatter: TimePeriodFormatterProtocol {
    
//    private let dateFormatter12Hrs: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.locale = Locale.current
//        formatter.dateFormat = "h:mma"
//        formatter.amSymbol = "am"
//        formatter.pmSymbol = "pm"
//        return formatter
//    }()
//
//    private let dateFormatter24Hrs: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.locale = Locale.current
//        formatter.dateFormat = "HH:mm"
//        return formatter
//    }()
    
    
//    init(locale: Locale = .current) {
//    }

    
    
    func getTimePeriod(from startDate: Date, durationMins: Int) -> String {
        let startTime = getLocalisedStringTime(from: startDate)
        
        let endDate = Date.calendar.date(byAdding: .minute, value: durationMins, to: startDate)!
        let endTime = getLocalisedStringTime(from: endDate)
        
        return "\(startTime) - \(endTime)"
    }
    
    func getLocalisedStringTime(from date: Date) -> String {
        return DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
    }
}
