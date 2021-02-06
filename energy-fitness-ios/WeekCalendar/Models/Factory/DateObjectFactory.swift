//
//  DateObjectFactory.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 06/02/2021.
//

import Foundation

class DateObjectFactory {
    private let monthFactory: MonthFactoryProtocol
    
    init(monthFactory: MonthFactoryProtocol) {
        self.monthFactory = monthFactory
    }
    
    func create(from date: Date) -> DateObject {
        return DateObject(day: date.get(.day),
                          month: monthFactory.create(from: date.get(.month))!,
                          year: date.get(.year))
    }
}
