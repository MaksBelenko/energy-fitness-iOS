//
//  MockTimePeriodFormatter.swift
//  UnitTests
//
//  Created by Maksim on 01/03/2021.
//

import Foundation
@testable import EnergyFitnessApp

class MockTimePeriodFormatter: TimePeriodFormatterProtocol {
    
    private let returnValue: String
    
    init(returnValue: String) {
        self.returnValue = returnValue
    }
    
    func getTimePeriod(from startDate: Date, durationMins: Int) -> String {
        return returnValue
    }
    
    func getLocalisedStringTime(from date: Date) -> String {
        return returnValue
    }
    
    
}
