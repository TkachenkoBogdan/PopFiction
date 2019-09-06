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
    
    private(set) var stack = CoreDataStack(modelName: "PopFiction")// а зачем здесь var если ты нигде не меняешь его?
    
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
    
    private func synchronizeFavorite(for article: Article) {//не очень удачное название, напр: synchronize(article: Article) будет лучше, как по мне
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Article.id), article.id])
        
        guard let favoriteArticle = try? stack.persistentContext.fetch(request).first else { return }
        article.isFavorite = favoriteArticle.isFavorite
    }
    
    
    // MARK: - Controllers:
    func fetchFavorites() -> [Article] {//Ну по хорошему если у тебя нет `favorites`, то метод должен возвращать не пустой массив, а nil
        
        var request: NSFetchRequest<Article>
        request = Article.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "publishedDate",
                                                    ascending: false)]
       
        guard let results =  try? stack.persistentContext.fetch(request) else {
            return [Article]()
        }
        return results
    }
    
    func favoritesCount() -> Int {
        var request: NSFetchRequest<Article>
        request = Article.fetchRequest()
        request.resultType = .countResultType
        
        return (try? stack.persistentContext.count(for: request)) ?? 0
    }
    
    func favorite(_ article: Article) {// `makeFavorite`
        let attKeys = article.entity.attributesByName.keys.map { String($0) }//`attributesKeys`
        let attributes = article.dictionaryWithValues(forKeys: attKeys)
        
        let newArticle = Article(context: stack.persistentContext)
        newArticle.setValuesForKeys(attributes)
        saveContext()
        
        postStatusChange(for: newArticle.id, value: true)
    }
    
    func unfavorite(article id: Int64) {//`makeUnforite`
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Article.id), id])
        
        if let article = try? stack.persistentContext.fetch(request).first {
            stack.persistentContext.delete(article)
            saveContext()
            
            postStatusChange(for: id, value: false)
        }
        //переносы строки лишние
        //
    }
    
    private func postStatusChange(for id: Int64, value: Bool) {
        NotificationCenter.default.post(name: favoriteStatusDidChangeNotification,
                                        object: nil,
                                        userInfo: [updateFavoriteIDKey: id,
                                                   updateFavoriteStatusKey: value])
    }
}
