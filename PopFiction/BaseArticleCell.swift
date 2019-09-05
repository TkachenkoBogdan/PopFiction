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
    @IBOutlet private var bylineLabel: UILabel?
    
    func configureWith(article: Article) {
        self.titleLabel?.text = article.title
        self.bylineLabel?.text = article.byline
    }

}
