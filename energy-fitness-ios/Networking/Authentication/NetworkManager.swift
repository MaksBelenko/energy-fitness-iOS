//
//  NetworkManager.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/03/2021.
//

import Foundation
import Combine

struct NetworkManager {
    private let session: NetworkSession
    private let authenticator: Authenticator
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
        self.authenticator = Authenticator(session: session)
    }
    
//    func signin(with signinDto: SigninDto) -> AnyPublisher<Bool, Never> {
//        authenticator.signin(with: signinDto)
//    }
    
    
    func performAuthenticatedRequest() -> AnyPublisher<TestMessage, Error> {
        let url = URL(string: EnergyApi.baseURLString + "/auth/local/test")!
        let request = URLRequest(url: url)
        
        return authenticator.validToken()
            .flatMap { accessToken in
                // we can now use this token to authenticate the request
                session.publisher(for: request, token: accessToken)
            }
            .tryCatch { error -> AnyPublisher<Data, Error> in
//                guard let serviceError = error as? ServiceError,
//                      serviceError.errors.contains(ServiceErrorMessage.invalidToken) else {
//                    throw error
//                }
                
                return authenticator.validToken(forceRefresh: true)
                    .flatMap { token in
                        // we can now use this new token to authenticate the second attempt at making this request
                        session.publisher(for: url, token: token)
                    }
                    .eraseToAnyPublisher()
            }
            .decode(type: TestMessage.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct TestMessage: Decodable {
    let message: String
}
