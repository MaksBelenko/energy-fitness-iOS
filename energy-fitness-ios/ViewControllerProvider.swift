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
    
    init(
        scheduleVC: Provider<ScheduleViewController>,
        bookSessionVC: Provider<BookSessionViewController>
    ) {
        self.scheduleVCProvider = scheduleVC
        self.bookSessionVCProvider = bookSessionVC
    }
    
    func createScheduleVC() -> ScheduleViewController {
        return scheduleVCProvider.instance
    }
    
    func createBookSessionVC() -> BookSessionViewController {
        return bookSessionVCProvider.instance
    }
}
