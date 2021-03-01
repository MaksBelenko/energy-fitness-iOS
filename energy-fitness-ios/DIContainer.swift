//
//  DIContainer.swift
//  energy-fitness-iOS
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
        
        setupForNetworking(using: container)
        setupForWeekCalendar(using: container)
        setupForScheduleView(using: container)
        
        
        container.autoregister(ScheduleViewController.self, initializer: ScheduleViewController.init)
            .inObjectScope(.transient)
        
        container.register(MainTabControllerProtocol.self) { resolver in
            let vc1 = resolver.resolve(ScheduleViewController.self)!
            vc1.tabBarItem.image = UIImage(systemName: "calendar")
            let vc2 = resolver.resolve(ScheduleViewController.self)!
            vc2.tabBarItem.image = UIImage(systemName: "calendar")
            return MainTabBarController.create(viewControllers: [vc1, vc2])
        }
//        .inObjectScope(.transient)
    }
    
    // MARK: - Networking setup of container
    private func setupForNetworking(using container: Container) {
        container.autoregister(NetworkConstants.self, initializer: NetworkConstants.init)
        container.autoregister(IJsonDecoderWrapper.self, initializer: JSONDecoderWrapper.init)
        container.autoregister(NetworkAdapterProtocol.self, initializer: URLSessionAdapter.init)
        container.autoregister(NetworkServiceProtocol.self, initializer: NetworkService.init)
    }
    
    
    // MARK: - ScheduleView setup of container
    private func setupForScheduleView(using container: Container) {
        container.autoregister(TimePeriodFormatterProtocol.self, initializer: TimePeriodFormatter.init)
        container.autoregister(ScheduleOrganiserProtocol.self, initializer: ScheduleOrganiser.init)
        container.autoregister(ScheduleCellVMFactoryProtocol.self, initializer: ScheduleCellVMFactory.init)
        
        container.autoregister(ScheduleViewProtocol.self, initializer: ScheduleView.init)
            .inObjectScope(.transient)
        
        container.autoregister(ScheduleViewModelProtocol.self, initializer: ScheduleViewModel.init)
            .inObjectScope(.transient)
    }
    
    
    
    // MARK: - WeekCalendar setup of container
    private func setupForWeekCalendar(using container: Container) {
        container.autoregister(WeekdayFactoryProtocol.self, initializer: WeekdayFactory.init)
        container.autoregister(MonthFactoryProtocol.self, initializer: MonthFactory.init)
        container.autoregister(DateObjectFactoryProtocol.self, initializer: DateObjectFactory.init)
        container.autoregister(WeekCalendarVMProtocol.self, initializer: WeekCalendarViewModel.init)
            .inObjectScope(.transient)
    
        container.register(DateFinderProtocol.self) { resolver in
            let weekdayFactory = resolver.resolve(WeekdayFactoryProtocol.self)!
            return DateFinder(calendar: Date.calendar, weekdayFactory: weekdayFactory)
        }
        
        container.register(WeekCalendarData.self) { resolver in
            return WeekCalendarData(numberOfWeeks: 6, startDay: .Monday, headerSpacing: 10)
        }
        .inObjectScope(.transient)
        
        container.register(WeekCalendarViewProtocol.self) { resolver in
            let weeCalendarVM = resolver.resolve(WeekCalendarVMProtocol.self)!
            return WeekCalendarView.create(cellSpacing: 6, viewModel: weeCalendarVM)
        }
        .inObjectScope(.transient)
    }
}

