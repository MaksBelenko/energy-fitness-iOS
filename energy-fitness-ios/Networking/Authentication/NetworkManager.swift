//
//  NetworkManager.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/03/2021.
//

import Foundation
import Combine

struct TestMessage: Decodable {
    let message: String
}

final class NetworkManager {
    private let session: NetworkSession
    private let authenticator: Authenticator
    
    private let jsonDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .formatted(.iso8601Full)
        return d
    }()
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
        self.authenticator = Authenticator(session: session)
    }
    
    
    
    
    func isSignedIn() -> AnyPublisher<Bool, Never> {
        return authenticator.isSignedIn()
    }
    
    func signin(with signinDto: SigninDto) -> AnyPublisher<Bool, AuthError> {
        return authenticator.signin(with: signinDto)
    }
    
    
    func testAuthEndpoint() -> AnyPublisher<TestMessage, Error> {
        let request = URLRequest(endpoint: .authTest)
     
        return performAuthenticated(request: request)
            .decode(type: TestMessage.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetch<T: Decodable>(from endpoint: EnergyEndpoint, returnType: T.Type) -> AnyPublisher<T, Error> {
        let request = URLRequest(endpoint: endpoint)
        
//        let url = URL(string: "http://localhost:3000/api/gym-sessions")!
//        let dataTaskPublisher = urlSession.dataTaskPublisher(for: url)
        
        return session.publisher(for: request)
            .share()
//            .tryCatch { error -> AnyPublisher<(data: Data, response: URLResponse), Error> in
//                Log.exception(message: "Received error \(APIError.networkError(error))", "")
//                return dataTaskPublisher
//            }
            .decode(type: T.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    
    // MARK: - Authenticated call
    private func performAuthenticated(request: URLRequest) -> AnyPublisher<Data, Error> {
        
        return authenticator.getValidAccessToken()
            .flatMap { [session] accessToken in
                session.publisher(for: request, token: accessToken) // try request with accessToken
            }
            .tryCatch { [authenticator, session] error -> AnyPublisher<Data, Error> in
                guard let apiError = error as? APIError,
                      apiError == .requestError(401) else { // check if the access is unauthorised (401)
                    throw error
                }
                
                return authenticator.getValidAccessToken(forceRefresh: true)
                    .flatMap { accessToken in
                        session.publisher(for: request, token: accessToken) // try again with new access token
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

