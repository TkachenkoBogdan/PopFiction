//
//  DataManager.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/5/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

  private let modelName: String

  init(modelName: String) {
    self.modelName = modelName
  }

  lazy var inMemoryContext: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()
    
  lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.newBackgroundContext()
  }()

  private lazy var storeContainer: NSPersistentContainer = {

    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  func saveContext () {
    guard mainContext.hasChanges else { return }
 
    do {
      try mainContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }
}
