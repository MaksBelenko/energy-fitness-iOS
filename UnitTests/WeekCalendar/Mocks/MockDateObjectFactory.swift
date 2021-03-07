//
//  MockDateObjectFactory.swift
//  UnitTests
//
//  Created by Maksim on 07/03/2021.
//

import Foundation
@testable import EnergyFitnessApp

class MockDateObjectFactory: DateObjectFactoryProtocol {
    
    private let createObject: DateObject
    private let createByAddingDaysObject: DateObject
    
    init(createObject: DateObject, createByAddingDaysObject: DateObject) {
        self.createObject = createObject
        self.createByAddingDaysObject = createByAddingDaysObject
    }
    
    func create(from date: Date) -> DateObject {
        return createObject
    }
    
    func createByAddingDays(_ number: Int, to dateObject: DateObject) -> DateObject {
        return createByAddingDaysObject
    }
    
    
}
