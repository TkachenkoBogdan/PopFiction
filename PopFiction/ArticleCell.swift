//
//  ArticleCell.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/30/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var summaryLabel: UILabel?
    @IBOutlet private var bylineLabel: UILabel?
    @IBOutlet private var thumnailImageView: UIImageView?
    @IBOutlet private var favoriteImageView: UIImageView?
    
    func configureWith(article: Article) {
        self.titleLabel?.text = article.title
        self.summaryLabel?.text = article.abstract
        self.bylineLabel?.text = article.byline
        self.favoriteImageView?.image = article.isFavorite ?
            UIImage(named: "heart_filled") : nil
     
        guard let imageURL = article.imageUrl else { return }
        self.thumnailImageView?.sd_setImage(with: imageURL)
    }

}
