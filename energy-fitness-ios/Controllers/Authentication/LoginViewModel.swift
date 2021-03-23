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
    
    private let authenticator = Authenticator(session: URLSession.shared)
    
    
    func isValidInputs() -> AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(emailSubject, passwordSubject)
            .map { username, password in
                if username.count > 3 && password.count > 3 {
                    return true
                }
                return false
            }
            .eraseToAnyPublisher()
    }
    
//    func login() {
//        
//        authenticator.
//    }
}
