//
//  MonthFactory.swift
//  WeekCalendar
//
//  Created by Maksim on 25/10/2020.
//  Copyright © 2020 Maksim Belenko. All rights reserved.
//

import Foundation

class MonthFactory {
    
    private var dict = [Int : Month]()
    
    init() {
        registerMonthNames()
    }
    
    private func registerMonthNames() {
        dict[1] = .January
        dict[2] = .February
        dict[3] = .March
        dict[4] = .April
        dict[5] = .May
        dict[6] = .June
        dict[7] = .July
        dict[8] = .August
        dict[9] = .September
        dict[10] = .October
        dict[11] = .November
        dict[12] = .December
    }
    
    func create(from monthNumber: Int) -> Month? {
        return dict[monthNumber]
    }
}
