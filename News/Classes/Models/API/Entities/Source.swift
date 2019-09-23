//
//  Source.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import Foundation
import ObjectMapper

let newsType: [SourceType] = []

enum SourceType: String, Codable {
    case unknown = ""
    case twentyFoutTV = "24tv.ua"
    case espresoTV = "Espreso.tv"
    case pravda = "Pravda.com.ua"
    case gazeta = "Gazeta.ua"
    case radioSvoboda = "Radiosvoboda.org"
    case pingvin = "Pingvin.pro"
    case korispondent = "Korrespondent.net"
}

class Source: ImmutableMappable {
    let id: String?
    let name: String
    
    required init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("name")
    }
    
    func mapping(map: Map) {
        id >>> map["id"]
        name >>> map["name"]
    }
}
