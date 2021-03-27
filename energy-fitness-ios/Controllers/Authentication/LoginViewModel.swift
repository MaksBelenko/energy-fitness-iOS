//
//  LoginViewModel.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/03/2021.
//

import Foundation
import Combine

enum SigninError: Error {
    case signinFailed
}

final class LoginViewModel {
    
    var emailSubject = CurrentValueSubject<String, Never>("")
    var passwordSubject = CurrentValueSubject<String, Never>("")
    
    private var emailValidSubject = CurrentValueSubject<Bool, Never>(false)
    private var passwordValidSubject = CurrentValueSubject<Bool, Never>(false)
    
//    private let authenticator = Authenticator(session: URLSession.shared)
    private let validator = Validator()
    private let networkManager = NetworkManager(session: URLSession.shared)
    
    
    func isValidInputs() -> AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(isEmailValid(), isPasswordValid())
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    func isEmailValid() -> AnyPublisher<Bool, Never> {
        return emailSubject
            .flatMap(validator.isEmail)
            .eraseToAnyPublisher()
    }
    
    func isPasswordValid() -> AnyPublisher<Bool, Never> {
        return passwordSubject
            .flatMap(validator.isSecurePassword)
            .eraseToAnyPublisher()
    }
    
    func signinAction() -> AnyPublisher<Bool, Never> {
        let signinDto = SigninDto(email: emailSubject.value.lowercased(), password: passwordSubject.value)

        return networkManager.signin(with: signinDto)
            .print("Authentication signin")
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
    func performTestRequest() -> AnyPublisher<TestMessage, Never> {
        return networkManager.testAuthEndpoint()
            .replaceError(with: TestMessage(message: "not successful request, probably error with authentication"))
            .eraseToAnyPublisher()
    }
    
}
