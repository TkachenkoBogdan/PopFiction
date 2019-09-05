//
//  ControllerFactory.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/31/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit

struct ArticleControllerFactory {
    
    private let articleService: ArticleService
    
    init(withService service: ArticleService) {
        self.articleService = service
    }
    
     func makeControllerFor(category: ArticleCategory) -> ArticleListController {
        let controller = UIStoryboard.main.instantiateViewController(ArticleListController.self)
        
        let item = UITabBarItem(title: category.title,
                                image: category.image,
                                selectedImage: nil)
        controller.dataSource = ArticleDataSource(with: articleService, category: category)
        controller.tabBarItem = item
        
        return controller
    }
    
}
