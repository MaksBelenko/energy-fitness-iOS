//
//  AuthError.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/03/2021.
//

import Foundation

enum AuthError: Error, CustomStringConvertible {
    case network
    case unauthorised
    case encoding
    case decoding
    case unknown
    
    var description: String {
        switch self {
        case .network:
          return "Request to API Server failed"
        case .encoding:
          return "Failed encoding the body message"
        case .decoding:
            return "Failed to decode the response"
        case .unauthorised:
          return "Access unauthorised"
        case .unknown:
          return "An unknown error occurred"
        }
    }
}
