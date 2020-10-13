//
//  DateHelper.swift
//  Cart Flow
//
//  Created by Scott Quintana on 10/13/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import Foundation

class DateHelper {
    static var monthDayYearDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()

    static func convertToMonthDayYearFormat(_ date: Date) -> String {
        return monthDayYearDateFormatter.string(from: date)
    }
}
