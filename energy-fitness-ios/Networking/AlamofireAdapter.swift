//
//  AlamofireAdapter.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 10/02/2021.
//

import Foundation
import Alamofire

class AlamofireAdapter: NetworkAdapterProtocol {
    
    func request<T>(_ urlRequest: URLRequest, returnType: T.Type, completion: @escaping (Result<T, APIError>) -> ()) throws where T : Decodable {
        <#code#>
    }
    
    
    func request<T>(method: HttpNetworkMethod, apiRoute: ApiRoute, returnType: T.Type, completion: @escaping (T) -> ()) throws where T : Decodable {
        
    }
    
    
    
    func request() {
        AF.request("http://localhost:3000/api/gym-classes").response { response in
            debugPrint(response)
        }
    }
}
