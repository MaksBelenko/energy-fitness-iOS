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
    
    private let authenticator = Authenticator(session: URLSession.shared)
    private let validator = Validator()
    
    
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
    
}
