//
//  Request.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 05/03/2021.
//

import Foundation

struct Request {
   let builder: RequestBuilderProtocol
   let completion: (Result<Data, APIError>) -> Void
    
   init(builder: RequestBuilderProtocol, completion: @escaping (Result<Data, APIError>) -> Void) {
      self.builder = builder
      self.completion = completion
   }
}
