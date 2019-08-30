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
            guard let mostEmailed = root.viewControllers?[0] as? ArticleListViewController else { return true }
            guard let mostShared = root.viewControllers?[1] as? ArticleListViewController else { return true }
            guard let mostViewed = root.viewControllers?[2] as? ArticleListViewController else { return true }
            mostEmailed.category = .mostEmailed
            mostShared.category = .mostShared(.facebook)
            mostViewed.category = .mostViewed
        }
        
        
        
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
      
        coreDataStack.saveContext()
    }

}
