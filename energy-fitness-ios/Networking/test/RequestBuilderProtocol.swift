//
//  RequestBuilderProtocol.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 05/03/2021.
//

import Foundation

protocol RequestBuilderProtocol {
    func withBaseURL(_ baseURL: URL) -> RequestBuilder
    @discardableResult func withHttpMethod(_ method: HTTPMethod) -> RequestBuilder
    @discardableResult func withPath(_ path: String) -> RequestBuilder
    @discardableResult func withHeaderField(for header: String, value: String) -> RequestBuilder
    @discardableResult func withQueryParam(name: String, value: String) -> RequestBuilder
    func build() -> URLRequest
}

class RequestBuilder: RequestBuilderProtocol {
    var method: HTTPMethod = .get
    var baseURL: URL?
    var path: String?
    var headers: [String: String] = [:]
    var queryParams: [URLQueryItem] = []
    
    
    func withBaseURL(_ baseURL: URL) -> RequestBuilder {
        self.baseURL = baseURL
        return self
    }
    
    @discardableResult
    func withHttpMethod(_ method: HTTPMethod) -> RequestBuilder {
        self.method = method
        return self
    }
    
    @discardableResult
    func withPath(_ path: String) -> RequestBuilder {
        self.path = path
        return self
    }
    
    @discardableResult
    func withHeaderField(for header: String, value: String) -> RequestBuilder {
        self.headers[header] = value
        return self
    }
    
    @discardableResult
    func withQueryParam(name: String, value: String) -> RequestBuilder {
        let queryItem = URLQueryItem(name: name, value: value)
        queryParams.append(queryItem)
        return self
    }
    
    
    func build() -> URLRequest {
        guard let baseURL = baseURL else {
            fatalError("Base URL should be set")
        }
        
        let urlWithPath = (path == nil) ? baseURL : baseURL.appendingPathComponent(path!)
        
        var components = URLComponents(url: urlWithPath, resolvingAgainstBaseURL: false)!
        components.queryItems = queryParams
        let url = components.url!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue.uppercased()
        
        return request
    }
}
