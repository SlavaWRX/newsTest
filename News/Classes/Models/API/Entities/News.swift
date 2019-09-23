//
//  News.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import Foundation
import ObjectMapper

class News: ImmutableMappable {
    let articles: [NewsDescriptions]
    let totalResults: Int?
    
    required init(map: Map) throws {
        articles = try map.value("articles")
        totalResults = try map.value("totalResults")
    }
    
    func mapping(map: Map) {
        articles >>> map["articles"]
        totalResults >>> map["totalResults"]
    }
}
