//
//  WebService.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire
import ObjectMapper


#if DEBUG
//let webPlugins = [PluginType]()
let webPlugins = [NetworkLoggerPlugin(verbose: true)]
#else
let webPlugins = [PluginType]()
#endif

typealias Error = Swift.Error

class RxNetworkProvider<Target>: MoyaProvider<Target> where Target: TargetType {
    
    // MARK: - Instance initialization
    
    override init(endpointClosure: @escaping EndpointClosure = RxNetworkProvider.webServiceEndpointMapping,
                  requestClosure: @escaping RequestClosure = RxNetworkProvider.defaultRequestMapping,
                  stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  manager: Manager = RxNetworkProvider<Target>.webServiceAlamofireManager(),
                  plugins: [PluginType] = webPlugins,
                  trackInflights: Bool = false) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
    
    
    // MARK: - Class methods
    
    class func webServiceEndpointMapping(_ target: Target) -> Endpoint {
        var stringURL: String!
        if target.path.hasPrefix("http") {
            stringURL = target.path
        } else {
            if target.path.count > 0 {
                stringURL = target.baseURL.appendingPathComponent(target.path).absoluteString.removingPercentEncoding
            } else {
                stringURL = target.baseURL.absoluteString
            }
        }
        
        let headers: [String: String] = target.headers ?? [:]
        
        return Endpoint(url: stringURL, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: headers)
    }
    
    class func webServiceAlamofireManager() -> Manager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = Constants.API.requestTimeOut
        configuration.httpMaximumConnectionsPerHost = 3
        
        let sharedCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        URLCache.shared = sharedCache
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        
        return manager
    }
    
    
    // MARK: - Interface methods
    
    func request<T: BaseMappable>(_ token: Target, keyPath: String? = nil) -> Observable<[T]>{
        return request(token)
            .map(keyPath)
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func request<T: BaseMappable>(_ token: Target, keyPath: String? = nil) -> Observable<T>{
        return request(token)
            .map(keyPath)
            .observeOn(MainScheduler.asyncInstance)
    }
    
    
    // MARK: - Private methods
    
    private func request(_ token: Target, shouldRefreshToken: Bool = true) -> Observable<Response> {
        return rx.request(token)
            .asObservable()
            .filter(statusCodes: Constants.API.validStatusCodeRange)
            .catchError({ [unowned self] error -> Observable<Response> in
                return self.extractError(error)
            })
    }
    
    
    private func extractError(_ aError: Error) -> Observable<Response> {
        var error: Error = aError
        guard let moyaError = error as? MoyaError else {
            return Observable.error(error)
        }
        
        switch moyaError {
        case .statusCode(let reponse),
             .jsonMapping(let reponse):
            if let jsonObject = try? reponse.mapJSON(),
                let serverError = try? Mapper<ServerErrorResponse>().map(JSON: jsonObject as! [String : Any]) {
                error = MoyaError.underlying(serverError, reponse)
            }
        default:
            break;
        }
        
        return Observable.error(error)
    }
}
