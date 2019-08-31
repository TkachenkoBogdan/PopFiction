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
            
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            
            guard let mostEmailed = sb.instantiateViewController(
                withIdentifier: articleListControllerIdentifier) as? UINavigationController else { return true }
            guard let mostShared = sb.instantiateViewController(
                withIdentifier: articleListControllerIdentifier) as? UINavigationController else { return true }
            guard let mostViewed = sb.instantiateViewController(
                withIdentifier: articleListControllerIdentifier) as? UINavigationController else { return true }
            guard let favorites = sb.instantiateViewController(
                withIdentifier: articleListControllerIdentifier) as? UINavigationController else { return true }
            
            
//            mostEmailed.category = .mostEmailed
//            mostShared.category = .mostShared(.facebook)
//            mostViewed.category = .mostViewed
//            favorites.category = .mostShared(.twitter)
//
            root.viewControllers = [mostEmailed,mostShared,mostViewed,favorites]
        }
        
        
        
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
      
        coreDataStack.saveContext()
    }

}
