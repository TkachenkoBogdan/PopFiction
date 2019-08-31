//
//  AppDelegate.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/29/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var  coreDataStack = CoreDataStack(modelName: "PopFiction")


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        
        if let root = window?.rootViewController as? UITabBarController {
            
            
            let mostEmailed = ArticleControllerFactory.makeControllerFor(category: .mostEmailed)
                .embeddedInNavigatioController()
            let mostShared = ArticleControllerFactory.makeControllerFor(category: .mostShared(.facebook))
                .embeddedInNavigatioController()
            let mostViewed = ArticleControllerFactory.makeControllerFor(category: .mostViewed)
                .embeddedInNavigatioController()
            let favorites = ArticleControllerFactory.makeControllerFor(category: .mostShared(.twitter))
                .embeddedInNavigatioController()
            
            
    
//            let mostEmailed = UIStoryboard.main.instantiateViewController(ArticleListController.self)
//            let mostShared = UIStoryboard.main.instantiateViewController(ArticleListController.self)
//            let mostViewed = UIStoryboard.main.instantiateViewController(ArticleListController.self)
//            let favorites = UIStoryboard.main.instantiateViewController(ArticleListController.self)
//
//            mostEmailed.category = .mostEmailed
//            mostShared.category = .mostShared(.facebook)
//            mostViewed.category = .mostViewed
//            favorites.category = .mostShared(.twitter)
            
            
            
//            guard let mostEmailed = sb.instantiateViewController(
//                withIdentifier: articleListControllerIdentifier) as? UINavigationController else { return true }
//            guard let mostShared = sb.instantiateViewController(
//                withIdentifier: articleListControllerIdentifier) as? UINavigationController else { return true }
//            guard let mostViewed = sb.instantiateViewController(
//                withIdentifier: articleListControllerIdentifier) as? UINavigationController else { return true }
//            guard let favorites = sb.instantiateViewController(
//                withIdentifier: articleListControllerIdentifier) as? UINavigationController else { return true }
//
            
//            mostEmailed.category = .mostEmailed
//            mostShared.category = .mostShared(.facebook)
//            mostViewed.category = .mostViewed
//            favorites.category = .mostShared(.twitter)
//
            root.viewControllers = [mostEmailed, mostShared, mostViewed, favorites]
        }
        
        
        
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
      
        coreDataStack.saveContext()
    }

}
