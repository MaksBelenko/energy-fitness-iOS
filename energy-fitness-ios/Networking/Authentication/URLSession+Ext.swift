//
//  URLSession+Exr.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/03/2021.
//

import Foundation
import Combine

protocol NetworkSession: AnyObject {
    func publisher(for url: URL, token: String?) -> AnyPublisher<Data, Error>
}

enum ServiceErrorMessage: String, Decodable, Error {
    case invalidToken = "invalid_token"
}

extension URLSession: NetworkSession {
    func publisher(for url: URL, token: String?) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authentication")
        }
        
        return dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    
                    let error = try JSONDecoder().decode(ServiceError.self, from: result.data)
                    throw error
                }
                
                return result.data
            }
            .eraseToAnyPublisher()
    }
}
