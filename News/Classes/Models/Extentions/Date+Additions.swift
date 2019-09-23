//
//  Date+Additions.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import Foundation
import SwiftDate

extension DateFormatter {
    
    struct News {
        static let publishedDate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            let currentTimeZoneOffset = TimeZone.current.secondsFromGMT()
            formatter.timeZone = TimeZone(secondsFromGMT: currentTimeZoneOffset)
            return formatter
        }()
    }
}
