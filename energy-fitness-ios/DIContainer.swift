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
        setupForCoordinators(using: container)
        setupForControllers(using: container)
        setupForRepository(using: container)
        setupForNetworking(using: container)
        setupForWeekCalendar(using: container)
        setupForScheduleView(using: container)
        
        setupForUtils(using: container)
    }
    
    
    
    
    // MARK: - Coordinators setup of container
    private func setupForCoordinators(using container: Container) {
        container.autoregister(ScheduleTabCoordinator.self, initializer: ScheduleTabCoordinator.init)
//            .inObjectScope(.transient)
        container.autoregister(AuthCoordinator.self, initializer: AuthCoordinator.init)
    }
    
    // MARK: - Controllers setup of container
    private func setupForControllers(using container: Container) {
        container.register(ViewControllerProvider.self) {
            ViewControllerProvider(scheduleVC: $0.resolve(Provider<ScheduleViewController>.self)!,
                                   bookSessionVC: $0.resolve(Provider<BookSessionViewController>.self)!,
                                   loginVCProvider: $0.resolve(Provider<LoginViewController>.self)!)
        }

        
        container.autoregister(MainTabControllerProtocol.self, initializer: MainTabBarController.init)
            .inObjectScope(.transient)
        
        /* Schedule Tab */
        container.autoregister(ScheduleViewController.self, initializer: ScheduleViewController.init)
            .inObjectScope(.transient)
        
        container.autoregister(BookSessionViewController.self, initializer: BookSessionViewController.init)
            .inObjectScope(.transient)
        container.autoregister(BookViewModel.self, initializer: BookViewModel.init)
            .inObjectScope(.transient)
        
        /* Auth */
        container.autoregister(LoginViewController.self, initializer: LoginViewController.init)
            .inObjectScope(.transient)
        container.autoregister(LoginViewModel.self, initializer: LoginViewModel.init)
            .inObjectScope(.transient)
        
    }
    
    // MARK: - Utils setup of container
    private func setupForUtils(using container: Container) {
        container.autoregister(TimePeriodFormatter.self, initializer: TimePeriodFormatter.init)
            .inObjectScope(.transient)
    }
    
    
    // MARK: - Repository for data setup of container
    private func setupForRepository(using container: Container) {
        container.autoregister(DataRepository.self, initializer: DataRepository.init)
    }
    
    // MARK: - Networking setup of container
    private func setupForNetworking(using container: Container) {
        container.autoregister(NetworkFetchOperationFactoryProtocol.self, initializer: ApiFetchOperationFactory.init)
        container.autoregister(ImageDownloadOperationFactory.self, initializer: ImageDownloadOperationFactory.init)
        
        container.autoregister(IJsonDecoderWrapper.self, initializer: JSONDecoderWrapper.init)
        container.autoregister(NetworkServiceProtocol.self, initializer: NetworkService123.init)
        container.autoregister(NetworkAdapterProtocol.self, initializer: URLSessionAdapter.init)
        container.autoregister(RequestBuilderProtocol.self, initializer: RequestBuilder.init)
    }
    
    
    // MARK: - ScheduleView setup of container
    private func setupForScheduleView(using container: Container) {
        container.autoregister(TimePeriodFormatterProtocol.self, initializer: TimePeriodFormatter.init)
        container.autoregister(ScheduleOrganiserProtocol.self, initializer: ScheduleOrganiser.init)

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

