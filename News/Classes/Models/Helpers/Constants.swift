//
//  Constants.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import Foundation

struct Constants {
    struct API {
        static let baseAPIURL = "https://newsapi.org/v2/top-headlines"
        static let apiKey = "81ba5eb68eac41358fa7dd524e62a3f5"
        static let country = "ua"
        static let validStatusCodeRange = ClosedRange(uncheckedBounds: (lower: 200, upper: 300))
        static let requestTimeOut = 15.0
        
        static let errorDomain = ""
        static let parseErrorCode = 123
    }
}
