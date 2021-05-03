//
//  ViewControllerProvider.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 14/03/2021.
//

import Foundation
import Swinject

final class ViewControllerProvider {
    private let scheduleVCProvider: Provider<ScheduleViewController>
    private let bookSessionVCProvider: Provider<BookSessionViewController>
    private let loginVCProvider: Provider<LoginViewController>
    private let signupVCProvider: Provider<SignupViewController>
    
    init(
        scheduleVC: Provider<ScheduleViewController>,
        bookSessionVC: Provider<BookSessionViewController>,
        loginVCProvider: Provider<LoginViewController>,
        signupVCProvider: Provider<SignupViewController>
    ) {
        self.scheduleVCProvider = scheduleVC
        self.bookSessionVCProvider = bookSessionVC
        self.loginVCProvider = loginVCProvider
        self.signupVCProvider = signupVCProvider
    }
    
    func createScheduleVC() -> ScheduleViewController {
        return scheduleVCProvider.instance
    }
    
    func createBookSessionVC() -> BookSessionViewController {
        return bookSessionVCProvider.instance
    }
    
    func createLoginVC() -> LoginViewController {
        return loginVCProvider.instance
    }
    
    func createSignupVC() -> SignupViewController {
        return signupVCProvider.instance
    }
}
