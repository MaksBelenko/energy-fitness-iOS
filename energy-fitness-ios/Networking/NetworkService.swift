//
//  NetworkService.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 20/02/2021.
//

import UIKit.UIImage

protocol NetworkServiceProtocol {
    func getAllSessions(completion: @escaping ([GymSessionDto]) -> ())
    func downloadImage(for imageRouteType: ImageDownloadRoute, imageName: String, completion: @escaping (UIImage) -> ())
}

class NetworkService: NetworkServiceProtocol {
    
    private var networkOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 10
        return operationQueue
    }()
    
    private let apiFetchOperationFactory: ApiFetchOperationFactoryProtocol
    private let requestBuilder: RequestBuilderProtocol
    private let imageDownloadOperationFactory: ImageDownloadOperationFactory
    
    private lazy var getAllGymClassesRequest: URLRequest = {
        let request = requestBuilder
                        .withBaseURL(EnergyApi.baseURL)
                        .withPath(ApiRoute.GymSessions.rawValue)
                        .build()
        return request
    }()
    
    
    // MARK: - Lifecycle
    init(
        requestBuilder: RequestBuilderProtocol,
        apiFetchOperationFactory: ApiFetchOperationFactoryProtocol,
        imageDownloadOperationFactory: ImageDownloadOperationFactory
    ) {
        self.requestBuilder = requestBuilder
        self.apiFetchOperationFactory = apiFetchOperationFactory
        self.imageDownloadOperationFactory = imageDownloadOperationFactory
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    
    
    func getAllSessions(completion: @escaping ([GymSessionDto]) -> ()) {
        let request = getAllGymClassesRequest

        let fetchGymClassesOperation = apiFetchOperationFactory.create(urlRequest: request, returnType: [GymSessionDto].self)
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
    
    
    func downloadImage(for imageRouteType: ImageDownloadRoute, imageName: String, completion: @escaping (UIImage) -> ()) {
        let path = imageRouteType.rawValue + "/" + imageName
        
        let request = requestBuilder
                        .withBaseURL(EnergyApi.baseURL)
                        .withPath(path) //("/trainers/image/download/Евгений_Рябов-small-6e69bad5-5267-4de1-858a-3860ca41533a.png")
                        .build()
        
        let imageDownloadOperation = imageDownloadOperationFactory.create(urlRequest: request)
        
        imageDownloadOperation.onResult = { result in
            switch result {
            case .success(let image):
                completion(image)
        
            case .failure(let error):
                Log.exception(message: "Error \(error.localizedDescription) appeared when fetching", error)
            }
        }
        
        networkOperationQueue.addOperation(imageDownloadOperation)
    }
    
//    func getAllTrainers(completion: @escaping ([TrainerDto]) -> ()) {
//        try! networkAdapter.request(method: .get, apiRoute: .Trainers, returnType: [Trainer].self, completion: completion)
//    }
}
