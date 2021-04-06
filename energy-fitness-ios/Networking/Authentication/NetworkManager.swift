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

