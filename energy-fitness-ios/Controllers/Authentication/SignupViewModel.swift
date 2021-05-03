//
//  SignupViewModel.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 03/05/2021.
//

import Foundation
import Combine

final class SignupViewModel {
    var fullNameSubject = CurrentValueSubject<String, Never>("")
    var emailSubject = CurrentValueSubject<String, Never>("")
    var passwordSubject = CurrentValueSubject<String, Never>("")
    
    private var fullNameValid = CurrentValueSubject<Bool, Never>(false)
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
    
    // MARK: - Validation
    func isValidInputs() -> AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3(isEmailValid(), isPasswordValid(), isFullNameValid())
            .map { $0 && $1 && $2 }
            .eraseToAnyPublisher()
    }
    
    func isFullNameValid() -> AnyPublisher<Bool, Never> {
        return fullNameSubject
            .flatMap(inputValidator.isName)
            .share()
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
    
    
    // MARK: - Networking
    
//    func signinAction() -> AnyPublisher<Bool, Never> {
//        let signinDto = SigninDto(email: emailSubject.value.lowercased(), password: passwordSubject.value)
//
//        return networkManager.signin(with: signinDto)
//            .print("Authentication signin")
//            .replaceError(with: false)
//            .eraseToAnyPublisher()
//    }
    
//    func performTestRequest() -> AnyPublisher<TestMessage, Never> {
//        return networkManager.testAuthEndpoint()
//            .replaceError(with: TestMessage(message: "not successful request, probably error with authentication"))
//            .eraseToAnyPublisher()
//    }
}
