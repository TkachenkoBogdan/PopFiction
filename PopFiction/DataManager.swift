//
//  DataManager.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/5/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import Foundation
import CoreData

final class DataManager {
    
    private let stack = CoreDataStack(modelName: "PopFiction")
    static let shared = DataManager()
    
    func saveContext () {
        self.stack.saveContext()
    }
    
    func makeArticle(withTitle title: String,
                     abstract: String,
                     byline: String,
                     url: URL?,
                     id: Int64,
                     publishDate: NSDate,
                     thumbnailURL: URL,
                     largeURL: URL ) -> Article {
        
        let article = Article(context: stack.inMemoryContext)
        article.title = title
        article.summary = abstract
        article.byline = byline
        article.url = url
        article.id = id
        article.publishedDate = publishDate
        
        article.smallImageUrl = thumbnailURL
        article.largeImageUrl = largeURL
        
        synchronize(article: article)
        return article
    }
    
    private func synchronize(article: Article) {
        let request = makeRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Article.id), article.id])
        
        guard let favoriteArticle = try? stack.mainContext.fetch(request).first else { return }
        article.isFavorite = favoriteArticle.isFavorite
    }
    
    
    // MARK: - Controllers:
    
    func fetchFavorites() -> [Article]? {
        let request = makeRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "publishedDate",
                                                    ascending: false)]
        guard let results = try? stack.mainContext.fetch(request) else {
            return nil
        }
        return results
    }
    
    func favoritesCount() -> Int {
        let request = makeRequest()
        request.resultType = .countResultType
        return (try? stack.mainContext.count(for: request)) ?? 0
    }
    
    func makeFavorite(_ article: Article) {
        let attributeKeys = article.entity.attributesByName.keys.map { String($0) }
        let attributes = article.dictionaryWithValues(forKeys: attributeKeys)
        
        let newArticle = Article(context: stack.mainContext)
        newArticle.setValuesForKeys(attributes)
        saveContext()
        
        postStatusChange(for: newArticle.id, value: true)
    }
    
    func makeUnfavorite(article id: Int64) {
        let request = makeRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Article.id), id])
        
        if let article = try? stack.mainContext.fetch(request).first {
            stack.mainContext.delete(article)
            saveContext()

            postStatusChange(for: id, value: false)
        }
    }
    
    private func makeRequest() -> NSFetchRequest<Article> {
        return Article.fetchRequest()
    }
}



//// MARK: - : Notifications:
extension DataManager {
    private func postStatusChange(for id: Int64, value: Bool) {
        NotificationCenter.default.post(name: .FavoriteStatusDidChange,
                                        object: nil,
                                        userInfo: [Keys.updateFavoriteIDKey: id,
                                                   Keys.updateFavoriteStatusKey: value])
    }
    //Notification keys:
    struct Keys {
        static let updateFavoriteStatusKey = "favoriteStatus"
        static let updateFavoriteIDKey = "id"
    }
}

extension Notification.Name {
    static let FavoriteStatusDidChange = Notification.Name(rawValue: "favoriteStatusDidChange")
}
