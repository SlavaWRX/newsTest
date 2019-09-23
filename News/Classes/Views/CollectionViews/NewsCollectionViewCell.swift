//
//  NewsCollectionViewCell.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import UIKit
import Kingfisher

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var viewModel: NewsViewModel!
    
    
    // MARK: - Class methods
    
    class func cellSizeWith(_ viewModel: NewsViewModel,
                            containerSize: CGSize) -> CGSize {
        return CGSize(width: containerSize.width, height: 108)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    // MARK: - Interface methods
    
    func configureWith(_ viewModel: NewsViewModel) {
        sourceLabel.text = viewModel.news.source.name
        authorLabel.text = viewModel.news.author
        titleLabel.text = viewModel.news.title
        descriptionLabel.text = viewModel.news.description
        
        imageView.kf.setImage(with: URL(string: viewModel.news.imageURL ?? ""))
    }
    
}
