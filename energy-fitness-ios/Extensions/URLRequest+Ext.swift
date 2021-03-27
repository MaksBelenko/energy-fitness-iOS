//
//  URLRequest+Ext.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 27/03/2021.
//

import Foundation

extension URLRequest {
    mutating func setHeader(_ header: HTTPHeader, to value: String?) {
        self.setValue(value, forHTTPHeaderField: header.rawValue)
    }
    
    mutating func setHttpMethod(to method: HTTPMethod) {
        self.httpMethod = method.rawValue
    }
}

extension URLRequest {
    init(endpoint: EnergyEndpoint) {
        self.init(url: endpoint.url)
    }
}
