//
//  DIContainer.swift
//  energy-fitness-ios
//
//  Created by Maksim on 06/02/2021.
//

import UIKit
import Swinject
import SwinjectAutoregistration

class DIContainer {
    
    static var staticContainerSwiftUIPreviews: Container {
        get {
            let container = Container()
            DIContainer().setupContainer(using: container)
            return container
        }
    }
    
    func setupContainer(using container: Container) {
        
        setupForWeekCalendar(using: container)
        
        container.autoregister(ScheduleViewController.self, initializer: ScheduleViewController.init)
        
        container.register(MainTabControllerProtocol.self) { resolver in
            let vc1 = resolver.resolve(ScheduleViewController.self)!
            return MainTabBarController.create(viewControllers: [vc1])
        }
//        .inObjectScope(.container)
    }
    
    // MARK: - WeekCalendar setup of container
    private func setupForWeekCalendar(using container: Container) {
        
        container.autoregister(WeekdayFactoryProtocol.self, initializer: WeekdayFactory.init)
        container.autoregister(MonthFactoryProtocol.self, initializer: MonthFactory.init)
        container.autoregister(DateObjectFactoryProtocol.self, initializer: DateObjectFactory.init)
        container.autoregister(WeekCalendarVMProtocol.self, initializer: WeekCalendarViewModel.init)
    
        container.register(DateFinderProtocol.self) { resolver in
            let weekdayFactory = resolver.resolve(WeekdayFactoryProtocol.self)!
            return DateFinder(calendar: Date.calendar, weekdayFactory: weekdayFactory)
        }
        
        container.register(WeekCalendarData.self) { resolver in
            return WeekCalendarData(numberOfWeeks: 6, startDay: .Monday, headerSpacing: 10)
        }
        
        container.register(WeekCalendarViewProtocol.self) { resolver in
            let weeCalendarVM = resolver.resolve(WeekCalendarVMProtocol.self)!
            return WeekCalendarView.create(cellSpacing: 4, viewModel: weeCalendarVM)
        }
    }
}

