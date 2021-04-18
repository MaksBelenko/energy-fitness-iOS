//
//  Validator.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/03/2021.
//

import Foundation
import Combine

final class InputValidator {
    
    enum ValidationRegex: String {
        case emailRegex = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$"
        case passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
    }

    func isEmail(_ email: String) -> AnyPublisher<Bool, Never> {
        return validate(email, with: .emailRegex)
    }
    
    func isSecurePassword(_ password: String) -> AnyPublisher<Bool, Never> {
        return validate(password, with: .passwordRegex)
    }
    
    
    func validate(_ value: String, with type: ValidationRegex) -> AnyPublisher<Bool, Never> {
        return Just(value)
            .map {
                let test = NSPredicate(format:"SELF MATCHES[c] %@", type.rawValue)
                return test.evaluate(with: $0)
            }
            .eraseToAnyPublisher()
    }
}
