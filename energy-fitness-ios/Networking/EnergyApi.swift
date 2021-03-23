//
//  EnergyApi.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 05/03/2021.
//

import Foundation

struct EnergyApi {
    static let baseURLString = "http://localhost:3000/api"
    
    static var api: APIClient = {
        let configuration = URLSessionConfiguration.default
        
        let apiKey = "ey...."
        configuration.httpAdditionalHeaders = [
              "Authorization": "Bearer \(apiKey)"
        ]
        
        return APIClient(configuration: configuration)
    }()
}
