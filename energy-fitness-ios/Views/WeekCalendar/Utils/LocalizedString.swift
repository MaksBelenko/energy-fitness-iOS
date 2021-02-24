//
//  LocalizedString.swift
//  WeekCalendar
//
//  Created by Maksim on 25/10/2020.
//  Copyright © 2020 Maksim Belenko. All rights reserved.
//

import Foundation

struct LocalizedString: ExpressibleByStringLiteral, Equatable {

    let v: String

    init(key: String) {
        self.v = NSLocalizedString(key, comment: "")
    }
    init(localized: String) {
        self.v = localized
    }
    init(stringLiteral value:String) {
        self.init(key: value)
    }
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(key: value)
    }
    init(unicodeScalarLiteral value: String) {
        self.init(key: value)
    }
}

func == (lhs:LocalizedString, rhs:LocalizedString) -> Bool {
    return lhs.v == rhs.v
}
