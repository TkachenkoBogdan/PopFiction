//
//  Article+CoreDataProperties.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/29/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var abstract: String?
    @NSManaged public var byline: String?
    @NSManaged public var publishedDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var id: Int64
    @NSManaged public var imageUrl: URL?

}
