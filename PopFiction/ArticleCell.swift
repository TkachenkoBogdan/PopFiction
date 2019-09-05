//
//  ArticleCell.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/30/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleCell: BaseCell {

    @IBOutlet private var thumnailImageView: UIImageView?
    @IBOutlet private var favoriteImageView: UIImageView?
    
    override func configureWith(article: Article) {
        super.configureWith(article: article)
        self.favoriteImageView?.image = article.isFavorite ?
            R.image.heart_filled() : nil
        
        guard let imageURL = article.imageUrl else { return }
        self.thumnailImageView?.sd_setImage(with: imageURL,
                                            placeholderImage: R.image.img_placeholder())
    }

}
