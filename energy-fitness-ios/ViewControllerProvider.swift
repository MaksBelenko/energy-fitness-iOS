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
    private let bookFormVCProvider: Provider<BookFormViewController>
    
    init(
        scheduleVC: Provider<ScheduleViewController>,
        bookSessionVC: Provider<BookSessionViewController>,
        bookFormVCProvider: Provider<BookFormViewController>
    ) {
        self.scheduleVCProvider = scheduleVC
        self.bookSessionVCProvider = bookSessionVC
        self.bookFormVCProvider = bookFormVCProvider
    }
    
    func createScheduleVC() -> ScheduleViewController {
        return scheduleVCProvider.instance
    }
    
    func createBookSessionVC() -> BookSessionViewController {
        return bookSessionVCProvider.instance
    }
    
    func createBookFormVC() -> BookFormViewController {
        return bookFormVCProvider.instance
    }
}
