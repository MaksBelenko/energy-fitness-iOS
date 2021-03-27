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
    private let refreshTokenURL = EnergyApi.baseURLString + "/auth/local/token-refresh"
    private let signinURL = URL(string: EnergyApi.baseURLString + ApiRoute.localSignin.rawValue)!
    
    private let session: NetworkSession
    private var currentAccessToken: String? = "c2f69c1e-54df-40d0-bfd6-e2a440858af8"
    private var currentRefreshToken: String? = "f1fa8d64-d17b-4d9e-b637-f35b31bb30c7"
    private let queue = DispatchQueue(label: "com.belenko.authentication.\(UUID().uuidString)")
    
    // this publisher is shared amongst all calls that request a token refresh
    private var refreshPublisher: AnyPublisher<AccessToken, Error>?
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func validToken(forceRefresh: Bool = false) -> AnyPublisher<AccessToken, Error> {
        return queue.sync { [weak self] in
            // scenario 1: we're already loading a new token
            if let publisher = self?.refreshPublisher {
                return publisher
            }
            
            // scenario 2: we don't have refresh token at all, the user should log in
            guard let refreshToken = self?.currentRefreshToken else {
                return Fail(error: AuthenticationError.loginRequired)
                    .eraseToAnyPublisher()
            }
            
            // scenario 3: we already have access token and don't want to force a refresh
            if let accessToken = self?.currentAccessToken, !forceRefresh {
                return Just(accessToken)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            
            // scenario 4: we need a new set of tokens token
            let endpoint = URL(string: refreshTokenURL)!
            var request = URLRequest(url: endpoint)
            request.httpMethod = HTTPMethod.post.rawValue
            
            let publisher = session.publisher(for: request, token: refreshToken)
                .share()
                .decode(type: TokensDto.self, decoder: JSONDecoder())
                .print("Auth validToken schenario 4")
                .handleEvents(receiveOutput: { tokens in
                    self?.queue.sync {
                        print("---Tokens to change \(tokens)")
                        self?.currentAccessToken = tokens.accessToken
                        self?.currentRefreshToken = tokens.refreshToken
                    }
                }, receiveCompletion: { _ in
                    self?.queue.sync {
                        print("---Changing refreshPublisher to nil")
                        self?.refreshPublisher = nil
                    }
                })
                .print("Before map to accessToken")
                .map { $0.accessToken }
                .eraseToAnyPublisher()
            
            self?.refreshPublisher = publisher
            return publisher
        }
    }
    
    
    func signin(with signinDto: SigninDto) -> AnyPublisher<Bool, AuthError> {
        
        return Just(signinDto)
            .encode(encoder: JSONEncoder())
            .map { [signinURL] encodedData in
                var request = URLRequest(url: signinURL)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = HTTPMethod.post.getHttpMethodName()
                request.httpBody = encodedData
                return request
            }
            .flatMap { [session] request in
                return session.publisher(for: request)
                    .decode(type: TokensDto.self, decoder: JSONDecoder())
            }
            .mapError { error -> AuthError in
                switch error {
                case is URLError:
                    return .network
                case APIError.requestError(let httpCode):
                    return httpCode == 401 ? .unauthorised : .unknown
                case is EncodingError:
                    return .encoding
                case is DecodingError:
                    return .decoding
                default:
                    return error as? AuthError ?? .unknown
                }
            }
            .handleEvents(receiveOutput: { [weak self] tokens in
                print("Signin Retrieved tokens \(tokens)")
                self?.queue.sync {
                    self?.currentAccessToken = tokens.accessToken
                    self?.currentRefreshToken = tokens.refreshToken
                }
            })
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
}
