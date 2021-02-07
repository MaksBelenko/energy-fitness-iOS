//
//  DIContainer.swift
//  energy-fitness-ios
//
//  Created by Maksim on 06/02/2021.
//

import UIKit
import Swinject

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
        
        container.register(MainTabControllerProtocol.self) { resolver in
            let vc1 = resolver.resolve(ScheduleViewController.self)!
            return MainTabBarController.create(viewControllers: [vc1])
        }
//        .inObjectScope(.container)
        
        
        container.register(ScheduleViewController.self) { resolver in
            let weekCalendarView = resolver.resolve(WeekCalendarViewProtocol.self)!
            let vc = ScheduleViewController(weekCalendarView: weekCalendarView)
            vc.tabBarItem.image = UIImage(systemName: "calendar")
            return vc
        }
    }
    
    // MARK: - WeekCalendar setup of container
    private func setupForWeekCalendar(using container: Container) {
        container.register(WeekCalendarData.self) { resolver in
            return WeekCalendarData(numberOfWeeks: 6, startDay: .Monday, headerSpacing: 10)
        }
        
        container.register(DateFinderProtocol.self) { resolver in
            return DateFinder(calendar: Date.calendar)
        }
        
        container.register(WeekdayFactory.self) { resolver in
            return WeekdayFactory()
        }
        
        container.register(MonthFactory.self) { resolver in
            return MonthFactory()
        }
        
        container.register(DateObjectFactory.self) { resolver in
            let monthFactory = resolver.resolve(MonthFactory.self)!
            return DateObjectFactory(monthFactory: monthFactory)
        }
        
        container.register(WeekCalendarVMProtocol.self) { resolver in
            let data = resolver.resolve(WeekCalendarData.self)!
            let dateFinder = resolver.resolve(DateFinderProtocol.self)!
            let weekdayFactory = resolver.resolve(WeekdayFactory.self)!
            let monthFactory = resolver.resolve(MonthFactory.self)!
            let dateObjectFactory = resolver.resolve(DateObjectFactory.self)!
            
            
            return WeekCalendarViewModel(data: data,
                                         dateFinder: dateFinder,
                                         weekdayFactory: weekdayFactory,
                                         monthFactory: monthFactory,
                                         dateObjectFactory: dateObjectFactory)
        }
        
        container.register(WeekCalendarViewProtocol.self) { resolver in
            let weeCalendarVM = resolver.resolve(WeekCalendarVMProtocol.self)!
            return WeekCalendarView.create(cellSpacing: 4, viewModel: weeCalendarVM)
        }
    }
}
