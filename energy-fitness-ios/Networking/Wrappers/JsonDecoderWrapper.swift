//
//  JsonDecoderWrapper.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 10/02/2021.
//

import Foundation

protocol IJsonDecoderWrapper {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

class JSONDecoderWrapper: IJsonDecoderWrapper {
    
    private let decoder = JSONDecoder()
    
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try decoder.decode(type, from: data)
    }
}
