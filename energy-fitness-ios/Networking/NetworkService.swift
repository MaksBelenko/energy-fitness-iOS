//
//  NetworkService.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 20/02/2021.
//

import Foundation

protocol NetworkServiceProtocol {
}

class NetworkService: NetworkServiceProtocol {
    
    private let networkAdapter = URLSessionAdapter()
    
    func getAllGymClasses(completion: @escaping ([GymClass]) -> ()) {
        try! networkAdapter.request(method: .get, apiRoute: .GymClasses, returnType: [GymClass].self, completion: completion)
    }
    
    func getAllSessions(completion: @escaping ([GymSession]) -> ()) {
        try! networkAdapter.request(method: .get, apiRoute: .GymSessions, returnType: [GymSession].self, completion: completion)
    }
    
    func getAllTrainers(completion: @escaping ([Trainer]) -> ()) {
        try! networkAdapter.request(method: .get, apiRoute: .Trainers, returnType: [Trainer].self, completion: completion)
    }
}
