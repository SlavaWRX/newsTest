//
//  ServerErrorResponse.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import Foundation
import ObjectMapper

class ServerErrorResponse: ImmutableMappable, Error {
    let name: String
    let message: String
    let type: String
    let statusCode: Int
    
    required init(map: Map) throws {
        name = try map.value("name")
        message = try map.value("message")
        type = try map.value("type")
        statusCode = try map.value("statusCode")
    }
}
