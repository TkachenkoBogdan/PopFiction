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
    
    override func configureWith(article: Article) {
        super.configureWith(article: article)
        self.dateLabel?.text = dateToString(article.publishedDate as? Date ?? Date())
        
        guard let imageURL = article.largeImageUrl else { return }
        self.largeImageView?.sd_setImage(with: imageURL,
                                         placeholderImage: UIImage(named: "placeholder_large"))
        
   }
    
    
   private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date ) ?? ""
    }
}
