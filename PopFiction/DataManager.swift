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
    
    private(set) var stack = CoreDataStack(modelName: "PopFiction")
    
    static let shared = DataManager()
    
    
    func saveContext () {
        self.stack.saveContext()
    }
    
    func makeArticle(withTitle title: String,
                     abstract: String,
                     byline: String,
                     url: URL?,
                     id: Int64,
                     publishDate: NSDate?,
                     thumbnailURL: URL,
                     largeURL: URL ) -> Article {
        
        let article = Article(context: stack.ephemeralContext)
        article.title = title
        article.abstract = abstract
        article.byline = byline
        article.url = url
        article.id = id
        article.publishedDate = publishDate
        
        article.imageUrl = thumbnailURL
        article.largeImageUrl = largeURL
        
        synchronizeFavorite(for: article)
        return article
    }
    
    private func synchronizeFavorite(for article: Article) {
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Article.id), article.id])
        
        guard let favoriteArticle = try? stack.persistentContext.fetch(request).first else { return }
        article.isFavorite = favoriteArticle.isFavorite
    }
    
    
    // MARK: - Controllers:
    
    func fetchFavorites() -> [Article] {

        var request: NSFetchRequest<Article>
        request = Article.fetchRequest()

        guard let results =  try? stack.persistentContext.fetch(request) else {
             return [Article]()
        }
        return results
    }
    
    func setFavorite(_ article: Article) {
        let attKeys = article.entity.attributesByName.keys.map { String($0) }
        let attributes = article.dictionaryWithValues(forKeys: attKeys)
        
        let newArticle = Article(context: stack.persistentContext)
        newArticle.setValuesForKeys(attributes)
        saveContext()
    }
    
    func deleteArticle(withID id: Int64) {
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Article.id), id])
        
        if let article = try? stack.persistentContext.fetch(request).first {
            stack.persistentContext.delete(article)
            saveContext()
        }
    }
}
