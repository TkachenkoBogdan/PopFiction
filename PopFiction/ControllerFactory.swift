//
//  ControllerFactory.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/31/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit

struct ArticleControllerFactory {
    
    static func makeControllerFor(category: ArticleService.ArticleCategory) -> ArticleListController {
        let controller = UIStoryboard.main.instantiateViewController(ArticleListController.self)
        
        
        let item = UITabBarItem(title: category.title,
                                image: UIImage(named: "window"),
                                selectedImage: nil)
        controller.dataSource = ArticleDataSource(withCategory: category)
        controller.category = category
        controller.tabBarItem = item
        
        return controller
    }
    
}
