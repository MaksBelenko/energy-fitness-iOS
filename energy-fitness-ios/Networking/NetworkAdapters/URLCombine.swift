//
//  URLCombine.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 18/02/2021.
//

import Foundation
import Combine

class URLCombine {
    
    private let urlSession = URLSession.shared
    private let jsonDecoder: IJsonDecoderWrapper = JSONDecoderWrapper()
    
    func fetch<T: Decodable>(returnType: T.Type) -> AnyPublisher<T, Error> {
        
        let url = URL(string: "http://localhost:3000/api/gym-sessions")!
        let dataTaskPublisher = urlSession.dataTaskPublisher(for: url)
        
        return
            dataTaskPublisher
            .share()
//            .tryCatch { error -> AnyPublisher<(data: Data, response: URLResponse), Error> in
//                Log.exception(message: "Received error \(APIError.networkError(error))", "")
//                return dataTaskPublisher
//            }
            .tryMap { output in
                let response = output.response
                if let apiError = APIError.error(from: response) {
                    throw apiError
                }
                return output.data
            }
            .tryMap { [weak self] data in
                try self!.jsonDecoder.decode(T.self, from: data)
            }
            .eraseToAnyPublisher()
        
        
    }
}
