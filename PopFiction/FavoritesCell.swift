//
//  FavoritesCell.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/3/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit
import SDWebImage

class FavoritesCell: ArticleCell {

    @IBOutlet private var dateLabel: UILabel?
    @IBOutlet private var largeImageView: UIImageView?
    @IBOutlet private var summaryLabel: UILabel?
    
    override func configureWith(article: Article) {
        super.configureWith(article: article)
        self.dateLabel?.text = (article.publishedDate as Date?)?.toString()
        self.summaryLabel?.text = article.summary
        
        guard let imageURL = article.largeImageUrl else { return }
        self.largeImageView?.sd_setImage(with: imageURL,
                                         placeholderImage: R.image.placeholder_large())
   }

   
}
