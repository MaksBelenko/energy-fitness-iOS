//
//  MockWeekdayFactory.swift
//  UnitTests
//
//  Created by Maksim on 07/02/2021.
//

import Foundation
@testable import EnergyFitnessApp

class MockWeekdayFactory: WeekdayFactoryProtocol {
    
    private let expectedWeekday: WeekDay
    
    init(expectedWeekday: WeekDay) {
        self.expectedWeekday = expectedWeekday
    }
    
    func create(from day: Int) -> WeekDay? {
        return expectedWeekday
    }
}
