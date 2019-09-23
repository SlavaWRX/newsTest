//
//  News+Networking.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift

let newsProvider = RxNetworkProvider<NewsTerget>()

extension News {
    static func getNews(page: Int, perPage: Int) -> Observable<News> {
        return newsProvider.request(.getNews(page: page, perPage: perPage))
    }
}
