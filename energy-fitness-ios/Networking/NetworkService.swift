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
    private let requestBuilder: RequestBuilderProtocol
    
    private lazy var getAllGymClassesRequest: URLRequest = {
        let request = requestBuilder
                        .withBaseURL(EnergyApi.baseURL)
                        .withPath("/gym-classes")
                        .build()
        return request
    }()
    
    
    init(
        networkAdapter: NetworkAdapterProtocol,
        requestBuilder: RequestBuilderProtocol
    ) {
        self.networkAdapter = networkAdapter
        self.requestBuilder = requestBuilder
    }
    
    
    func getAllGymClasses(completion: @escaping ([GymClass]) -> ()) {
        let request = getAllGymClassesRequest
        
        try! networkAdapter.request(request, returnType: [GymClass].self, completion: { result in
            switch result {
               case .success(let gymClasses):
                    completion(gymClasses)
                
               case .failure(let error):
                Log.exception(message: "Received error \(error.localizedDescription) when fetching [GymClass]", error)
            }
        })
//        try! networkAdapter.request(method: .get, apiRoute: .GymClasses, returnType: [GymClass].self, completion: completion)
    }
    
    func getAllSessions(completion: @escaping ([GymSession]) -> ()) {
//        try! networkAdapter.request(method: .get, apiRoute: .GymSessions, returnType: [GymSession].self, completion: completion)
    }
    
    func getAllTrainers(completion: @escaping ([Trainer]) -> ()) {
//        try! networkAdapter.request(method: .get, apiRoute: .Trainers, returnType: [Trainer].self, completion: completion)
    }
}
