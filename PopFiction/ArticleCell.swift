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
    @IBOutlet private var thumnailView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(article: Article) {
        self.titleLabel?.text = article.title
        self.summaryLabel?.text = article.abstract
        self.bylineLabel?.text = article.byline
        guard let imageURL = article.imageUrl else { return }
        self.thumnailView?.sd_setImage(with: imageURL) { (image, error, cache, url) in
            print(image)
            print(url)
        }
    }

}
