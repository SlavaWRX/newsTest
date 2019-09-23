//
//  Observable+Response.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift
import Moya

extension ObservableType where E == Response {
    public func map<T: BaseMappable>(_ keyPath: String? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            Observable.create({ observer -> Disposable in
                do {
                    var json = try response.mapJSON()
                    if let keyPath = keyPath,
                        let aJson = json as? [String: Any] {
                        json = aJson[keyPath] as Any
                    }
                    
                    if let value = Mapper<T>().map(JSONObject: json) {
                        observer.onNext(value)
                    } else {
                        let error = NSError(domain:Constants.API.errorDomain,
                                            code: Constants.API.parseErrorCode,
                                            userInfo: [NSLocalizedDescriptionKey: "Failed to parse data from server"])
                        observer.onError(MoyaError.underlying(error, response))
                    }
                } catch {
                    observer.onError(error)
                }
                observer.onCompleted()
                return Disposables.create()
            })
        }
    }
    
    public func map<T: BaseMappable>(_ keyPath: String? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            Observable.create({ observer -> Disposable in
                do {
                    var json = try response.mapJSON()
                    if let keyPath = keyPath,
                        let aJson = json as? [String: Any] {
                        json = aJson[keyPath] as Any
                    }
                    
                    if let value = Mapper<T>().mapArray(JSONObject: json) {
                        observer.onNext(value)
                    } else {
                        let error = NSError(domain:Constants.API.errorDomain,
                                            code: Constants.API.parseErrorCode,
                                            userInfo: [NSLocalizedDescriptionKey: "Failed to parse data from server"])
                        observer.onError(MoyaError.underlying(error, response))
                    }
                } catch {
                    observer.onError(error)
                }
                observer.onCompleted()
                return Disposables.create()
            })
        }
    }
}
