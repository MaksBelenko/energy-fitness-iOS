//
//  Authenticator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/03/2021.
//

import Foundation
import Combine

typealias AccessToken = String

final class Authenticator {
    private let refreshTokenURL = EnergyApi.baseURLString + ApiRoute.refreshToken.rawValue
    
    private let session: NetworkSession
    private var currentAccessToken: String?
    private let queue = DispatchQueue(label: "com.belenko.authentication.\(UUID().uuidString)")
    
    // this publisher is shared amongst all calls that request a token refresh
    private var refreshPublisher: AnyPublisher<String, Error>?
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func validToken(forceRefresh: Bool = false) -> AnyPublisher<AccessToken, Error> {
        return queue.sync { [weak self] in
            // scenario 1: we're already loading a new token
            if let publisher = self?.refreshPublisher {
                return publisher
            }
            
            // scenario 2: we don't have a token at all, the user should probably log in
            guard let token = self?.currentAccessToken else {
                return Fail(error: AuthenticationError.loginRequired)
                    .eraseToAnyPublisher()
            }
            
            // scenario 3: we already have a valid token and don't want to force a refresh
//            if token.isValid, !forceRefresh {
//                return Just(token)
//                    .setFailureType(to: Error.self)
//                    .eraseToAnyPublisher()
//            }
            
            // scenario 4: we need a new token
            let endpoint = URL(string: refreshTokenURL)!
            let publisher = session.publisher(for: endpoint, token: nil)
                .share()
                .decode(type: TokensDto.self, decoder: JSONDecoder())
                .handleEvents(receiveOutput: { tokens in
                    self?.currentAccessToken = tokens.accessToken
                }, receiveCompletion: { _ in
                    self?.queue.sync {
                        self?.refreshPublisher = nil
                    }
                })
                .map { $0.accessToken }
                .eraseToAnyPublisher()
            
            self?.refreshPublisher = publisher
            return publisher
        }
    }
    
    func signin(with signinDto: SigninDto) -> AnyPublisher<TokensDto, Error> {
        return Just(signinDto)
            .encode(encoder: JSONEncoder())
//            .mapError { error -> APIError in
//                return APIError.encodingError(error.localizedDescription)
//            }
            .map { encodedData in
                var request = URLRequest(url: URL(string: "http://localhost:3000/api/auth/local/signin")!)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = HTTPMethod.post.getHttpMethodName()
                request.httpBody = encodedData
                return request
            }
            .flatMap { request in
                return URLSession.DataTaskPublisher(request: request, session: .shared)
                    .tryMap { output in
                        let response = output.response
                        if let apiError = APIError.error(from: response) {
                            throw apiError
                        }
                        return output.data
                    }
                    .decode(type: TokensDto.self, decoder: JSONDecoder())
            }
            .eraseToAnyPublisher()
    }
}
