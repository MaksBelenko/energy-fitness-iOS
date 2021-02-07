//
//  WeekDayFactory.swift
//  WeekCalendar
//
//  Created by Maksim on 25/10/2020.
//  Copyright © 2020 Maksim Belenko. All rights reserved.
//

import Foundation

class WeekdayFactory {
    
    private var dict = [Int : WeekDay]()
    
    init() {
        registerWeekDays()
    }
    
    private func registerWeekDays() {
        dict[1] = .Sunday
        dict[2] = .Monday
        dict[3] = .Tuesday
        dict[4] = .Wednesday
        dict[5] = .Thursday
        dict[6] = .Friday
        dict[7] = .Saturday
    }
    
    func create(from day: Int) -> WeekDay? {
        return dict[day]
    }
}
