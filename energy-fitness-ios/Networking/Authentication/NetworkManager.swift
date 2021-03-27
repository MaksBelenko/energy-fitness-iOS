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

struct NetworkManager {
    private let session: NetworkSession
    private let authenticator: Authenticator
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
        self.authenticator = Authenticator(session: session)
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
    
    
    func performAuthenticated(request: URLRequest) -> AnyPublisher<Data, Error> {
        
        return authenticator.getValidAccessToken()
            .flatMap { accessToken in
                // we can now use this token to authenticate the request
                session.publisher(for: request, token: accessToken)
            }
            .tryCatch { error -> AnyPublisher<Data, Error> in
                guard let apiError = error as? APIError else {
                    throw error
                }
                // not unauthorised or not forbidden
                if apiError != .requestError(401) || apiError != .requestError(403) {
                    throw apiError
                }
                
                return authenticator.getValidAccessToken(forceRefresh: true)
                    .flatMap { accessToken in
                        // we can now use this new token to authenticate the second attempt at making this request
                        session.publisher(for: request, token: accessToken)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

