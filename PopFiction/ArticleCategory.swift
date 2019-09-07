//
//  ArticleCategory.swift
//  
//
//  Created by Богдан Ткаченко on 9/4/19.
//

import UIKit

enum ArticleCategory {
    
    enum ShareType: String {
        case email, facebook, twitter
    }
    
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
        var image: UIImage
        switch self {
        case .mostEmailed:
            image = #imageLiteral(resourceName: "emailed")
        case .mostShared:
            image = #imageLiteral(resourceName: "shared")
        case .mostViewed:
            image = #imageLiteral(resourceName: "viewed")
        }
        return image
    }
}
