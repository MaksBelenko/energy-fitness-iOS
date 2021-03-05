//
//  ApiClient.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 05/03/2021.
//

import Foundation

struct APIClient {
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    func send(request: Request) {
        let urlRequest = request.builder.toURLRequest()
        let task = session.dataTask(with: urlRequest) { data, response, error in
            let result: Result<Data, APIError>
            if let error = error {
                result = .failure(.networkError(error))
            } else if let apiError = APIError.error(from: response) {
                result = .failure(apiError)
            } else {
                result = .success(data ?? Data())
            }
            DispatchQueue.main.async {
                request.completion(result)
            }
        }
        
        task.resume()
    }
}
