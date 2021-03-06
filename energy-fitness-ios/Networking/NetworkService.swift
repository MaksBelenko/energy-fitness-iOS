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
    
    
    private let apiFetchOperationFactory: ApiFetchOperationFactoryProtocol
    private let requestBuilder: RequestBuilderProtocol
    private var networkOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 10
        return operationQueue
    }()
    
    private lazy var getAllGymClassesRequest: URLRequest = {
        let request = requestBuilder
                        .withBaseURL(EnergyApi.baseURL)
                        .withPath(ApiRoute.GymSessions.rawValue)
                        .build()
        return request
    }()
    
    
    init(
        requestBuilder: RequestBuilderProtocol,
        apiFetchOperationFactory: ApiFetchOperationFactoryProtocol
    ) {
        self.requestBuilder = requestBuilder
        self.apiFetchOperationFactory = apiFetchOperationFactory
    }
    
    
    func getAllGymClasses(completion: @escaping ([GymClass]) -> ()) {
    }
    
    func getAllSessions(completion: @escaping ([GymSession]) -> ()) {
        let request = getAllGymClassesRequest

        let fetchGymClassesOperation = apiFetchOperationFactory.create(urlRequest: request, returnType: [GymSession].self)
        fetchGymClassesOperation.onResult = { result in
            switch result {
            case .success(let gymSessions):
                completion(gymSessions)
            
            case .failure(let error):
                Log.exception(message: "Error \(error.localizedDescription) appeared when fetching", error)
            }
        }
        
        networkOperationQueue.addOperation(fetchGymClassesOperation)
    }
    
    func getAllTrainers(completion: @escaping ([Trainer]) -> ()) {
//        try! networkAdapter.request(method: .get, apiRoute: .Trainers, returnType: [Trainer].self, completion: completion)
    }
}
