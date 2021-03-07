//
//  WeekCalendarViewModel.swift
//  WeekCalendar
//
//  Created by Maksim on 07/10/2020.
//  Copyright © 2020 Maksim Belenko. All rights reserved.
//

import Foundation
import UIKit

protocol WeekCalendarVMProtocol {
    func setSelectedCell(indexPath: IndexPath) -> IndexPath
    func getDate(from indexPath: IndexPath) -> DateObject
    func getNumberOfSections() -> Int
    func getNumberOfDays(for section: Int) -> Int
    func getDay(for indexPath: IndexPath) -> Day
    func getMonthName(for section: Int) -> String
    func getMonthNameSize(for section: Int) -> CGSize
}


class WeekCalendarViewModel: WeekCalendarVMProtocol {
    
    private let headerSpacing: CGFloat
    private let startWeekDay: WeekDay
    
    private let calendar = Date.calendar
    private let monthFactory: MonthFactoryProtocol
    private let dateObjectFactory: DateObjectFactoryProtocol
    private let weekdayFactory: WeekdayFactoryProtocol
    private let dateFinder: DateFinderProtocol
    
    private var months = [MonthData]()
    private var numberOfMonthsDifference: Int!
    private var selectedIndexPath: IndexPath!
    
    private lazy var todayDate = Date()
    
    
    // MARK: - Lifecycle
    
    init(data: WeekCalendarData,
         dateFinder: DateFinderProtocol,
         weekdayFactory: WeekdayFactoryProtocol,
         monthFactory: MonthFactoryProtocol,
         dateObjectFactory: DateObjectFactoryProtocol
    ) {
        self.dateFinder = dateFinder
        self.weekdayFactory = weekdayFactory
        self.monthFactory = monthFactory
        self.dateObjectFactory = dateObjectFactory
        
        
        self.headerSpacing = data.headerSpacing
        self.startWeekDay = data.startDay
        
//        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self.generateMetaData(for: data.numberOfWeeks)
//        }
    }
    
    
    // MARK: - Private methods
    
    private func generateMetaData(for numberOfWeeks: Int) {
        let currentWeekMondayDate = dateFinder.getWeekBeginDate(from: startWeekDay, date: todayDate)
        
        setSelectedIndex(firstDayDate: currentWeekMondayDate, todayDate: todayDate)
        
        let numberOfDays = numberOfWeeks * 7
        
        // Creating temporary to which 3 hours (to be safe, 1 hours is also enough) are
        // added in case of time change +/- 1 hours which happens twice a year
        let tmpDateForTimeChange = calendar.date(byAdding: .day, value: numberOfDays - 1, to: currentWeekMondayDate)!
        let lastDateToShow = calendar.date(byAdding: .hour, value: 3, to: tmpDateForTimeChange)!
        
        
        self.numberOfMonthsDifference = lastDateToShow.months(from: currentWeekMondayDate)
    
        if (numberOfMonthsDifference == 0) {
            let _ = populateMonth(from: currentWeekMondayDate, to: lastDateToShow)
            return
        }
        
        var lastDayDate = populateMonth(from: currentWeekMondayDate)
        
        for i in 0..<numberOfMonthsDifference {
            let firstDayDate = calendar.date(byAdding: .day, value: 1, to: lastDayDate)!
            lastDayDate = (i == numberOfMonthsDifference - 1)
                                ? populateMonth(from: firstDayDate, to: lastDateToShow)
                                : populateMonth(from: firstDayDate)
        }
        
    }
    

    private func setSelectedIndex(firstDayDate: Date, todayDate: Date) {
        let monthDifference = todayDate.months(from: firstDayDate)
        let dayDifference = todayDate.days(from: firstDayDate)
        
        let rowIndex = (monthDifference > 0)
                            ? todayDate.get(.day) - 1
                            : dayDifference
        
        selectedIndexPath = IndexPath(row: rowIndex, section: monthDifference)
    }
    
    
    private func populateMonth(from startDate: Date, to endDate: Date? = nil ) -> Date {
        
        let lastDayDate = (endDate != nil) ? endDate! : dateFinder.getLastDayOfMonth(from: startDate)
        
        let startDay = startDate.get(.day)
        let lastDay = lastDayDate.get(.day)
        let monthName = monthFactory.create(from: startDate.get(.month))!
        
        let monthData = MonthData(name: monthName,
                                  startDay: startDay,
                                  startDate: dateObjectFactory.create(from: startDate),
                                  totalDaysToShow: lastDay - startDay + 1)
        
        months.append(monthData)
        
        return lastDayDate
    }
    
    
    // MARK: - Public methods
    
    func setSelectedCell(indexPath: IndexPath) -> IndexPath {//(oldIndexPath: IndexPath, selectedDate: Date) {
        let oldIndexPath = selectedIndexPath!
        selectedIndexPath = indexPath
        return oldIndexPath
    }
    
    func getDate(from indexPath: IndexPath) -> DateObject {
        let startDayDateObject = months[indexPath.section].startDate
        let selectedDateObject = dateObjectFactory.createByAddingDays(indexPath.row, to: startDayDateObject)
        
        return selectedDateObject
    }
    
    
    func getNumberOfSections() -> Int {
        return numberOfMonthsDifference + 1
    }
    
    func getNumberOfDays(for section: Int) -> Int {
        return months[section].totalDaysToShow
    }
    
    
    func getDay(for indexPath: IndexPath) -> Day {
        let month = months[indexPath.section]
        let dayToShow = month.startDay + indexPath.row
        
        let dateObject = dateObjectFactory.createByAddingDays(indexPath.row, to: month.startDate)
        let date = dateObject.getDate()
        
        let weekDay = weekdayFactory.create(from: date.get(.weekday))!
        let selected = (selectedIndexPath == indexPath)
        
        return Day(number: dayToShow, weekDay: weekDay, isSelected: selected)
    }
    
    func getMonthName(for section: Int) -> String {
        return months[section].name.getLocalisedName()
    }
    
    func getMonthNameSize(for section: Int) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: UIFont.calendarDateFont(ofSize: 18)]
        let monthName = months[section].name.getLocalisedName()
        var size = (monthName as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        size.width += headerSpacing // spacing when two month are near each other
        return size
    }
}
