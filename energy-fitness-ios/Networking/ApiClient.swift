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
}
