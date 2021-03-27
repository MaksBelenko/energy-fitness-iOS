//
//  EnergyEnpoint.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 27/03/2021.
//

import Foundation

protocol EndpointResource {
    var baseURL: String { get }
    var endpoint: String { get }
    var url: URL { get }
}

enum EnergyEndpoint {
    case gymClasses
    case gymSessions
    case trainers
    case tokenRefresh
    case localSignin
    case authTest
}

extension EnergyEndpoint: EndpointResource {
    var baseURL: String {
        get { return "http://localhost:3000/api"}
    }
    
    var endpoint: String {
        switch self {
        case .gymClasses:
            return baseURL + "/gym-classes"
        case .gymSessions:
            return baseURL + "/gym-sessions"
        case .trainers:
            return baseURL + "/trainers"
        case .tokenRefresh:
            return baseURL + "/auth/local/token-refresh"
        case .localSignin:
            return baseURL + "/auth/local/signin"
        case .authTest:
            return baseURL + "/auth/local/test"
        }
    }
    
    var url: URL {
        return URL(string: self.endpoint)!
    }
}
