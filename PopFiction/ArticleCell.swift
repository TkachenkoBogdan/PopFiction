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
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let url = URL(string:"https://static01.nyt.com/images/2019/08/18/magazine/18mag-1619landing-hp1/18mag-1619landing-hp1-thumbStandard.jpg")
//        self.thumnailImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "img_placeholder") ?? UIImage())
        
    }

    func configureWith(article: Article) {
        self.titleLabel?.text = article.title
        self.summaryLabel?.text = article.abstract
        self.bylineLabel?.text = article.byline
        guard let imageURL = article.imageUrl else { return }
       
        self.thumnailImageView?.sd_setImage(with: imageURL)
    }

}
