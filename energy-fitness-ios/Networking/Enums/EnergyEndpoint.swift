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
    case gymClass(String)
    case gymClassImage(String)
    
    case gymSessions
    case gymSession(String)
    case trainers
    case trainer(String)
    case trainerImageDownload(String)
    
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
        case .gymClass(let id):
            return "\(EnergyEndpoint.gymClasses.endpoint)/\(id)"
        case .gymClassImage(let imageId):
            return "\(EnergyEndpoint.gymClasses.endpoint)/image/download/\(imageId)"
            
        case .gymSessions:
            return baseURL + "/gym-sessions"
        case .gymSession(let id):
            return "\(EnergyEndpoint.gymSessions.endpoint)/\(id)"
            
        case .trainers:
            return baseURL + "/trainers"
        case .trainer(let id):
            return "\(EnergyEndpoint.trainers.endpoint)/\(id)"
        case .trainerImageDownload(let imageName):
            return "\(EnergyEndpoint.trainers.endpoint)/image/download/\(imageName)"
            
        case .tokenRefresh:
            return baseURL + "/auth/local/token-refresh"
        case .localSignin:
            return baseURL + "/auth/local/signin"
        case .authTest:
            return baseURL + "/auth/local/test"
        }
    }
    
    var url: URL {
        return URL(string: self.endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
}
