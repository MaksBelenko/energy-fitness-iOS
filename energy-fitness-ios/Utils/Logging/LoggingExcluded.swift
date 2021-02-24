//
//  LoggingExcluded.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation


@propertyWrapper
struct LoggingExcluded<T> {
    var wrappedValue: T

    init(wrappedValue initialValue: T) {
        self.wrappedValue = initialValue
    }
}

extension LoggingExcluded: CustomStringConvertible, CustomDebugStringConvertible, CustomLeafReflectable {
    var description: String {
        return "_blank_"
    }
    
    var debugDescription: String {
        return "_blank_"
    }
    
    var customMirror: Mirror {
        return Mirror(reflecting: "_blank_")
    }
}
