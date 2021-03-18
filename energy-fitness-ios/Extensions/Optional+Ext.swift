//
//  Optional+Ext.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 15/03/2021.
//

import Foundation

struct NilError: Error {}

extension Optional {
    func unwrap(or error: @autoclosure () -> Error = NilError()) throws -> Wrapped {
        switch self {
        case .some(let w): return w
        case .none: throw error()
        }
    }
}
