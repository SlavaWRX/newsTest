//
//  NewsViewController.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import UIKit

import SafariServices

class NewsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let viewModel = NewsListViewModel()
    
    let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(actionRefresh(_:)), for: .valueChanged)
        return control
    }()
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    
    // MARK: - Override methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
        
        collectionView.addSubview(refreshControl)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        viewModel.delegate = self
        
        collectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newsCollectionViewCell")
        
        viewModel.updateHandler = { [weak self] in
            guard let welf = self else { return }
            welf.refreshControl.endRefreshing()
        }
    }
    
    
    // MARK: - Action methods
    
    @objc func actionRefresh(_ sender: Any) {
        collectionView.reloadData()
        viewModel.reloadData()
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        return
            //        let filNesw = self.filteredViewModels.filter({$0.news.source.name == "24tv.ua"})
            viewModel.filteredViewModels = viewModel.viewModels.filter( { filterNews -> Bool in
                return filterNews.news.type.rawValue == "Pravda.com.ua"
            })
        collectionView.reloadData()
    }
}

extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        cell.configureWith(viewModel.filteredViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return NewsCollectionViewCell.cellSizeWith(viewModel.filteredViewModels[indexPath.row], containerSize: collectionView.frame.size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 11.0, *) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            guard let urlPath = viewModel.filteredViewModels[indexPath.row].news.urlSource else {
                return
            }
            
            guard let url = URL(string: urlPath) else {
                return
            }
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        } else {
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom <= height {
            viewModel.loadMoreNews()
        }
    }
}

extension NewsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            viewModel.filteredViewModels = viewModel.viewModels
            collectionView.reloadData()
            return
        }
        viewModel.filteredViewModels = viewModel.viewModels.filter( { searchNews -> Bool in
            return searchNews.news.title?.contains(searchText) ?? false
        })
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
}

extension NewsViewController: NewsListViewModelDelegate {
    func newsListViewModelDidLoadNews(_ viewModel: NewsListViewModel) {
        activityIndicator.removeFromSuperview()
        collectionView.reloadData()
    }
}
