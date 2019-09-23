//
//  NewsDescriptions.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsDescriptions: ImmutableMappable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let imageURL: String?
    let urlSource: String?
    let publishedAt: String?
    
    let dateFormatter = DateFormatter.News.publishedDate
    
    var publishedDate: Date {
        let dateOne = publishedAt?.toDate()
        return dateOne!.date
    }
    
    var type: SourceType {
        if let result = SourceType(rawValue: source.name) {
            return result
        }
        return .unknown
    }
    
    required init(map: Map) throws {
        source = try map.value("source")
        author = try map.value("author")
        title = try map.value("title")
        description = try map.value("description")
        imageURL = try map.value("urlToImage")
        urlSource = try map.value("url")
        publishedAt = try map.value("publishedAt")
    }
    
    func mapping(map: Map) {
        source >>> map["source"]
        author >>> map["author"]
        title >>> map["title"]
        description >>> map["description"]
        imageURL >>> map["urlToImage"]
        urlSource >>> map["url"]
        publishedAt >>> map["publishedAt"]
    }
}
