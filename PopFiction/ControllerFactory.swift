//
//  ControllerFactory.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/31/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit

struct ArticleControllerFactory {
    
    static func makeControllerFor(category: ArticleCategory) -> ArticleListController {
        let controller = UIStoryboard.main.instantiateViewController(ArticleListController.self)
        
        
        let item = UITabBarItem(title: category.title,
                                image: category.image,
                                selectedImage: nil)
        controller.dataSource = ArticleDataSource(withCategory: category)
        controller.tabBarItem = item
        
        return controller
    }
    
}
