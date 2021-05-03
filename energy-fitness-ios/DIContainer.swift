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
            .inObjectScope(.transient)
    }
    
    // MARK: - Controllers setup of container
    private func setupForControllers(using container: Container) {
        container.register(ViewControllerProvider.self) {
            ViewControllerProvider(scheduleVC: $0.resolve(Provider<ScheduleViewController>.self)!,
                                   bookSessionVC: $0.resolve(Provider<BookSessionViewController>.self)!,
                                   loginVCProvider: $0.resolve(Provider<LoginViewController>.self)!,
                                   signupVCProvider: $0.resolve(Provider<SignupViewController>.self)!)
        }

        container.autoregister(AppCoordinator.self, initializer: AppCoordinator.init)
            .inObjectScope(.transient)
        
//        container.autoregister(MainTabControllerProtocol.self, initializer: MainTabBarController.init)
//            .inObjectScope(.transient)
        
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
        container.autoregister(SignupViewController.self, initializer: SignupViewController.init)
            .inObjectScope(.transient)
        container.autoregister(SignupViewModel.self, initializer: SignupViewModel.init)
            .inObjectScope(.transient)
        container.autoregister(InputValidator.self, initializer: InputValidator.init)
            .inObjectScope(.transient)
        
        
    }
    
    // MARK: - Utils setup of container
    private func setupForUtils(using container: Container) {
        container.autoregister(TimePeriodFormatter.self, initializer: TimePeriodFormatter.init)
            .inObjectScope(.transient)
    }
    
    // MARK: - Networking setup of container
    private func setupForNetworking(using container: Container) {
        container.autoregister(IJsonDecoderWrapper.self, initializer: JSONDecoderWrapper.init)
        container.autoregister(RequestBuilderProtocol.self, initializer: RequestBuilder.init)
        container.register(NetworkSession.self) { _ in return URLSession.shared }
        container.autoregister(Authenticator.self, initializer: Authenticator.init).inObjectScope(.container)
        container.autoregister(NetworkManager.self, initializer: NetworkManager.init).inObjectScope(.container)
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

