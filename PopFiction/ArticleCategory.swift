//
//  ArticleCategory.swift
//  
//
//  Created by Богдан Ткаченко on 9/4/19.
//

import UIKit

enum ArticleCategory {
    case mostEmailed, mostShared(ShareType), mostViewed
    
    var title: String {
        switch self {
        case .mostEmailed:
            return "Most Emailed"
        case .mostShared:
            return "Most Shared"
        case .mostViewed:
            return "Most Viewed"
        }
    }
    
    var image: UIImage {
        var image: UIImage?
        switch self {
        case .mostEmailed:
            image = R.image.emailed()
        case .mostShared:
            image = R.image.shared()
        case .mostViewed:
            image = R.image.viewed()
        }
        return image ?? UIImage()
    }
}

enum ShareType: String {
    case email, facebook, twitter
}
