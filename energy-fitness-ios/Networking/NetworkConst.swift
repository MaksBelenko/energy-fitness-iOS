//
//  NetworkConst.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 10/02/2021.
//

import Foundation

struct NetworkConstants {
    let baseUrl = "http://localhost:3000/api"
}

enum ApiRoute: String {
    case GymClasses = "/gym-classes"
    case GymSessions = "/gym-sessions"
    case Trainers = "/trainers"
}

enum HttpNetworkMethod: String {
    case get = "GET"
    case post = "POST"
}
