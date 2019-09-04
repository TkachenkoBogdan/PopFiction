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
        setRootController()
        
       

        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }

}

extension AppDelegate {
    
    private func setRootController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barStyle = .black
        self.window?.rootViewController = tabBarController
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        setTabBarControllers()
    }
    
    private func setTabBarControllers() {
        if let root = window?.rootViewController as? UITabBarController {
            
            let mostEmailed = ArticleControllerFactory.makeControllerFor(category: .mostEmailed)
            let mostShared = ArticleControllerFactory.makeControllerFor(category: .mostShared(.facebook))
            let mostViewed = ArticleControllerFactory.makeControllerFor(category: .mostViewed)
            
            let controllers: [UINavigationController] = [mostEmailed, mostShared, mostViewed].map { vc in
                vc.coreDataStack = self.coreDataStack
                return vc.embeddedInNavigatioController()
            }
            root.viewControllers = controllers
        }
    }
}
