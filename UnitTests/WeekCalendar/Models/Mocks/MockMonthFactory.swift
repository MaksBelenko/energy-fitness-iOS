//
//  MockMonthFactory.swift
//  UnitTests
//
//  Created by Maksim on 06/02/2021.
//

import Foundation
@testable import EnergyFitnessApp

class MockMonthFactory: MonthFactoryProtocol {
    
    func create(from monthNumber: Int) -> Month? {
        return .January
    }
}
