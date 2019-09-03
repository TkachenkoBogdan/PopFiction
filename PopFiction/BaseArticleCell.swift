//
//  BaseArticleCell.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/3/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit
import SDWebImage

class BaseCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var summaryLabel: UILabel?
    @IBOutlet private var bylineLabel: UILabel?
    @IBOutlet private var thumnailImageView: UIImageView?
    
    func configureWith(article: Article) {
        self.titleLabel?.text = article.title
        self.summaryLabel?.text = article.abstract
        self.bylineLabel?.text = article.byline
        
        guard let imageURL = article.imageUrl else { return }
        self.thumnailImageView?.sd_setImage(with: imageURL)
    }
    
}