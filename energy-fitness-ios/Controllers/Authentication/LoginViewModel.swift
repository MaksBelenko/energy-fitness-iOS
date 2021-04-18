//
//  LoginViewModel.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/03/2021.
//

import Foundation
import Combine

final class LoginViewModel {
    
    var emailSubject = CurrentValueSubject<String, Never>("")
    var passwordSubject = CurrentValueSubject<String, Never>("")
    
    private var emailValidSubject = CurrentValueSubject<Bool, Never>(false)
    private var passwordValidSubject = CurrentValueSubject<Bool, Never>(false)
    
    private let inputValidator: InputValidator
    private let networkManager: NetworkManager
    
    
    init(
        networkManager: NetworkManager,
        inputValidator: InputValidator
    ) {
        self.networkManager = networkManager
        self.inputValidator = inputValidator
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    
    func isValidInputs() -> AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(isEmailValid(), isPasswordValid())
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    func isEmailValid() -> AnyPublisher<Bool, Never> {
        return emailSubject
            .flatMap(inputValidator.isEmail)
            .share()
            .eraseToAnyPublisher()
    }
    
    func isPasswordValid() -> AnyPublisher<Bool, Never> {
        return passwordSubject
            .flatMap(inputValidator.isSecurePassword)
            .share()
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
