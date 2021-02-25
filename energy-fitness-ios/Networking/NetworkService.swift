//
//  NetworkService.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 20/02/2021.
//

import Foundation

protocol NetworkServiceProtocol {
    func getAllGymClasses(completion: @escaping ([GymClass]) -> ())
    func getAllSessions(completion: @escaping ([GymSession]) -> ())
    func getAllTrainers(completion: @escaping ([Trainer]) -> ())
}

class NetworkService: NetworkServiceProtocol {
    
    private let networkAdapter: NetworkAdapterProtocol
    
    init(networkAdapter: NetworkAdapterProtocol) {
        self.networkAdapter = networkAdapter
    }
    
    
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
