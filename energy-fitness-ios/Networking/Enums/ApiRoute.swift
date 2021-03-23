//
//  ApiRoute.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 05/03/2021.
//

import Foundation

enum ApiRoute: String {
    case gymClasses = "/gym-classes"
    case gymSessions = "/gym-sessions"
    case trainers = "/trainers"
    case refreshToken = "/auth/local/token-refresh"
}

enum ImageDownloadRoute: String {
    case trainer = "/trainers/image/download"
}
