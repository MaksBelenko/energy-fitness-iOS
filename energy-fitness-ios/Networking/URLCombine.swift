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
    
    func fetch<T: Decodable>() -> AnyPublisher<T, Error> {
        
        let url = URL(string: "http://localhost:3000/api/gym-classes")!
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { [weak self] data, _ in
                try self!.jsonDecoder.decode(T.self, from: data)
            }
            .eraseToAnyPublisher()
    }
}
