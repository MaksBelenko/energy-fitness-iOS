//
//  HTTPMethod.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 05/03/2021.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}

extension HTTPMethod {
    func getString() -> String {
        return self.rawValue.uppercased()
    }
}
