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
    func publisher(for urlRequest: URLRequest) -> AnyPublisher<Data, Error>
}

enum ServiceErrorMessage: String, Decodable, Error {
    case invalidToken = "invalid_token"
}

extension URLSession: NetworkSession {
    func publisher(for request: URLRequest) -> AnyPublisher<Data, Error> {
        return dataTaskPublisher(for: request)
            .tryMap { result in
                let response = result.response
                if let apiError = APIError.error(from: response) {
                    throw apiError
                }
                return result.data
            }
            .eraseToAnyPublisher()
    }
    
    func publisher(for url: URL, token: String?) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authentication")
        }
        
        return publisher(for: request)
    }
}
