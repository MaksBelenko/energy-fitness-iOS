//
//  WeekViewBuilder.swift
//  WeekCalendar
//
//  Created by Maksim on 03/02/2021.
//  Copyright © 2021 Maksim Belenko. All rights reserved.
//

import Foundation
import CoreGraphics

class WeekViewBuilder {
    
    private var spacing: CGFloat = 4
    private var numberOfWeeks = 4
    private var firstDayOfWeek: WeekDay = .Monday
    private var headerSpacing: CGFloat = 10
    
    
    /**
     Changes the number of weeks that will be shown (default 4)
     
     - Parameter numberOfWeeks: Number of weeks to be shown from today
     */
    @discardableResult
    func withNumberOfWeeks(_ numberOfWeeks: Int) -> WeekViewBuilder {
        self.numberOfWeeks = numberOfWeeks
        return self
    }
    
    /**
     Sets the first day of the week (default is .Monday)
     
     - Parameter startDay: First day of the week (default is .Monday)
     */
    @discardableResult
    func withFirstDayOfWeek(_ startDay: WeekDay) -> WeekViewBuilder {
        self.firstDayOfWeek = startDay
        return self
    }
    
    /**
     Spacing between month names when scrolling from one month to another
     
     - Parameter headerSpacing: Months headers spacing when the approach each other
                                (defaut is 10)
     */
    @discardableResult
    func withMonthNameHeaderSpacing(_ headerSpacing: CGFloat) -> WeekViewBuilder {
        self.headerSpacing = headerSpacing
        return self
    }

    /**
     Adds spacing between the date items
     
     This is a spacing between the items (date). Left and right items will
     have half a spacing on the ends
     - Parameter spacing: Spacing (default is 4)
     */
    @discardableResult
    func withBetweenItemSpacing(_ spacing: CGFloat) -> WeekViewBuilder {
        self.spacing = spacing
        return self
    }
    

    
    func build() -> WeekCalendarView {
        let weekView = WeekCalendarView.create(weeksToShow: numberOfWeeks,
                                               spacing: spacing,
                                               headerSpacing: headerSpacing,
                                               startWeekDay: firstDayOfWeek)
        return weekView
    }
}
