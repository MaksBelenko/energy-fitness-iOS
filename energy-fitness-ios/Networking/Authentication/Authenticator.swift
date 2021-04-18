//
//  Authenticator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/03/2021.
//

import Foundation
import Combine

enum AuthenticationError: Error {
    case loginRequired
}

final class Authenticator {
    private let tokenRefreshURL = EnergyEndpoint.tokenRefresh.url
    private let signinURL = EnergyEndpoint.localSignin.url
    
    private let session: NetworkSession
    private let queue = DispatchQueue(label: "com.belenko.authentication.\(UUID().uuidString)")
    
    typealias AccessToken = String
    private lazy var refreshTokenPublisher = CurrentValueSubject<String?, Never>(currentRefreshToken)
    private var currentAccessToken: String?
    private var currentRefreshToken: String? {
        didSet {
            refreshTokenPublisher.send(currentRefreshToken)
        }
    }
    
    // this publisher is shared amongst all calls that request a token refresh
    private var refreshPublisher: AnyPublisher<AccessToken, Error>?
    
    // MARK: - Lifecycle
    init(session: NetworkSession) {
        self.session = session
    }
    
    // MARK: - Public methods
    func isSignedIn() -> AnyPublisher<Bool, Never> {
        return refreshTokenPublisher
            .print("TTT: hh")
            .receive(on: DispatchQueue.main)
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    func getValidAccessToken(forceRefresh: Bool = false) -> AnyPublisher<AccessToken, Error> {
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
            var request = URLRequest(endpoint: .tokenRefresh)
            request.setHttpMethod(to: .post)
            
            let publisher = session.publisher(for: request, token: refreshToken)
                .share()
                .decode(type: TokensDto.self, decoder: JSONDecoder())
                .log { "Auth validToken scenario 4 received tokens = \n\($0)" }
                .tryCatch { error -> AnyPublisher<TokensDto, Error> in
                    if let error = error as? APIError, error == .requestError(401) {
                        self?.setTokensSync(access: nil, refresh: nil)
                    }
                    throw error
                }
                .handleEvents(receiveOutput: { tokens in
                    self?.setTokensSync(access: tokens.accessToken, refresh: tokens.refreshToken)
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
    
    
    func signin(with signinDto: SigninDto) -> AnyPublisher<Bool, AuthError> {
        
        return Just(signinDto)
            .encode(encoder: JSONEncoder())
            .map { [signinURL] encodedData in
                var request = URLRequest(url: signinURL)
                request.setHeader(.contentType, to: "application/json")
                request.setHttpMethod(to: .post)
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
                self?.setTokensSync(access: tokens.accessToken, refresh: tokens.refreshToken)
            })
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    
    
    private func setTokensSync(access: String?, refresh: String?) {
        queue.sync { [weak self] in
            self?.currentAccessToken = access
            self?.currentRefreshToken = refresh
        }
    }
}
