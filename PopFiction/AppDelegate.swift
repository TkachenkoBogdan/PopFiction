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
        setTabBarControllers()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }

}

extension AppDelegate {
    private func setTabBarControllers() {
        if let root = window?.rootViewController as? UITabBarController {
            
            let mostEmailed = ArticleControllerFactory.makeControllerFor(category: .mostEmailed)
                .embeddedInNavigatioController()
            let mostShared = ArticleControllerFactory.makeControllerFor(category: .mostShared(.facebook))
                .embeddedInNavigatioController()
            let mostViewed = ArticleControllerFactory.makeControllerFor(category: .mostViewed)
                .embeddedInNavigatioController()
            let favorites = ArticleControllerFactory.makeControllerFor(category: .mostShared(.twitter))
                .embeddedInNavigatioController()
            
            root.viewControllers = [mostEmailed, mostShared, mostViewed, favorites]
        }
    }
}
