//
//  Authenticator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 22/03/2021.
//

import Foundation
import Combine


//enum ServiceErrorMessage: String, Decodable, Error {
//    case invalidToken = "invalid_token"
//}

struct ServiceError: Decodable, Error {
    let errors: [ServiceErrorMessage]
}

//protocol NetworkSession: AnyObject {
//    func publisher(for url: URL, token: Token?) -> AnyPublisher<Data, Error>
//}

enum AuthenticationError: Error {
    case loginRequired
}

//extension URLSession: NetworkSession {
//    func publisher(for url: URL, token: Token?) -> AnyPublisher<Data, Error> {
//        var request = URLRequest(url: url)
//        if let token = token {
//            request.setValue("Bearer <access token>", forHTTPHeaderField: "Authentication")
//        }
//        
//        return dataTaskPublisher(for: request)
//            .tryMap { result in
//                guard let httpResponse = result.response as? HTTPURLResponse,
//                      httpResponse.statusCode == 200 else {
//                    
//                    let error = try JSONDecoder().decode(ServiceError.self, from: result.data)
//                    throw error
//                }
//                
//                return result.data
//            }
//            .eraseToAnyPublisher()
//    }
//}


//struct NetworkManager {
//    private let session: NetworkSession
//    private let authenticator: Authenticator_TEST
//    
//    init(session: NetworkSession = URLSession.shared) {
//        self.session = session
//        self.authenticator = Authenticator_TEST(session: session)
//    }
//    
//    func performAuthenticatedRequest() -> AnyPublisher<Response, Error> {
//        let url = URL(string: "https://some")!
//        
//        return authenticator.validToken()
//            .flatMap { token in
//                // we can now use this token to authenticate the request
//                session.publisher(for: url, token: token)
//            }
//            .tryCatch { error -> AnyPublisher<Data, Error> in
//                guard let serviceError = error as? ServiceError,
//                      serviceError.errors.contains(ServiceErrorMessage.invalidToken) else {
//                    throw error
//                }
//                
//                return authenticator.validToken(forceRefresh: true)
//                    .flatMap { token in
//                        // we can now use this new token to authenticate the second attempt at making this request
//                        session.publisher(for: url, token: token)
//                    }
//                    .eraseToAnyPublisher()
//            }
//            .decode(type: Response.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
//}



//final class Authenticator_TEST {
//    private let session: NetworkSession
//    private var currentToken: Token? = Token(isValid: false)
//    private let queue = DispatchQueue(label: "com.belenko.authentication.\(UUID().uuidString)")
//    
//    // this publisher is shared amongst all calls that request a token refresh
//    private var refreshPublisher: AnyPublisher<Token, Error>?
//    
//    init(session: NetworkSession = URLSession.shared) {
//        self.session = session
//    }
//    
//    func validToken(forceRefresh: Bool = false) -> AnyPublisher<Token, Error> {
//        return queue.sync { [weak self] in
//            // scenario 1: we're already loading a new token
//            if let publisher = self?.refreshPublisher {
//                return publisher
//            }
//            
//            // scenario 2: we don't have a token at all, the user should probably log in
//            guard let token = self?.currentToken else {
//                return Fail(error: AuthenticationError.loginRequired)
//                    .eraseToAnyPublisher()
//            }
//            
//            // scenario 3: we already have a valid token and don't want to force a refresh
//            if token.isValid, !forceRefresh {
//                return Just(token)
//                    .setFailureType(to: Error.self)
//                    .eraseToAnyPublisher()
//            }
//            
//            // scenario 4: we need a new token
//            let endpoint = URL(string: "https://dome/refresh")!
//            let publisher = session.publisher(for: endpoint, token: nil)
//                .share()
//                .decode(type: Token.self, decoder: JSONDecoder())
//                .handleEvents(receiveOutput: { token in
//                    self?.currentToken = token
//                }, receiveCompletion: { _ in
//                    self?.queue.sync {
//                        self?.refreshPublisher = nil
//                    }
//                })
//                .eraseToAnyPublisher()
//            
//            self?.refreshPublisher = publisher
//            return publisher
//        }
//    }
//}
