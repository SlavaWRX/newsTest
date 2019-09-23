//
//  NewsListViewModel.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftDate

typealias EmptyClosure = () -> Void

protocol NewsListViewModelDelegate: class {
    func newsListViewModelDidLoadNews(_ viewModel: NewsListViewModel)
}

class NewsListViewModel {
    
    var updateHandler: EmptyClosure?
    
    private (set) var error: Error?
    private (set) var totalResults: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    private (set) var viewModels = [NewsViewModel]() {
        didSet {
            updateHandler?()
        }
    }
    var filteredViewModels = [NewsViewModel]()
    private let loadingViewModel = UIActivityIndicatorView()
    private var requestDisoseBag = DisposeBag()
    private var isLoading = false
    weak var delegate: NewsListViewModelDelegate?
    
    //    let newsType = SourceType()
    
    var totalPerPage = 0
    var maximumPerPage = 10
    var page = 1
    
    let dateFormatterPrint = DateFormatter()
    
    
    // MARK: - Intance intialization
    
    init() {
        loadNews()
    }
    
    
    // MARK: - Interface methods
    
    func loadMoreNews() {
        if isLoading {
            return
        }
        guard totalPerPage != totalResults.value else {
            return
        }
        page += 1
        loadNews()
    }
    
    func reloadData() {
        totalPerPage = 0
        page = 1
        viewModels.removeAll()
        requestDisoseBag = DisposeBag()
        isLoading = false
        loadNews()
    }
    
    func filterNews() {
        let filNesw = self.filteredViewModels.filter({$0.news.source.name == "24tv.ua"})
        print(filNesw)
    }
    
    func loadNews() {
        isLoading = true
        totalPerPage += maximumPerPage
        let observable = News.getNews(page: page, perPage: maximumPerPage)
        observable.subscribe(onNext: { [unowned self] news in
            self.totalResults.accept(news.totalResults)
            news.articles.forEach { news in
                let viewModel = NewsViewModel(news: news)
                print("type: \(viewModel.news.type)")
                self.viewModels.append(viewModel)
                self.viewModels.sort(by: { (n1, n2) -> Bool in
                    return n1.news.publishedDate > n2.news.publishedDate
                })
                self.filteredViewModels = self.viewModels
                
            }
            }, onError: { [weak self] error in
                self?.error = error
            }, onDisposed: { [weak self] in
                guard let welf = self else {
                    return
                }
                welf.isLoading = false
                welf.delegate?.newsListViewModelDidLoadNews(welf)
        }).disposed(by: requestDisoseBag)
    }
}
