//
//  ArticleService.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/29/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData
import Rswift

class ArticleService {
    
    private let networkService: ArticleNetworkService
    
    public static let shared = ArticleService()
    
    init(networkService: ArticleNetworkService = ArticleNetworkService()) {
        self.networkService = networkService
    }
    
    private let context = (UIApplication.shared.delegate
        as? AppDelegate)?.coreDataStack.managedContext
    
 
    func fetchArticles(for category: ArticleCategory = .mostViewed,
                       completionHandler: @escaping (Result<[Article], Error>) -> Void) {
        
        networkService.fetchArticles(forCategory: category) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let articles = self.makeArticles(from: data) else { return }
                    completionHandler(Result.success(articles))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                    return
                }
            }
        }
    }
    
    private func makeArticles(from data: Data) -> [Article]? {
        if let json = try? JSON.init(data: data) {
            var articles: [Article] = []
            
            guard let topContainer = json["results"].array else { return nil }
            for article in topContainer {
                let title = article["title"].stringValue
                let abstract = article["abstract"].stringValue
                let byline = article["byline"].stringValue
                let url = article["url"].url
                let id = article["id"].int64Value
                let publishDate = article["published_date"].stringValue
                
                guard let mediaContainer = article["media"].array?.first  else { return nil}
                
                guard let stringURLThumbnail = mediaContainer["media-metadata"][0]["url"].string,
                    let thumbnailURL = URL(string: stringURLThumbnail) else { return nil }
                
                guard let stringURLLarge = mediaContainer["media-metadata"][2]["url"].string,
                    let largeURL = URL(string: stringURLLarge) else { return nil}
                
                if let newArticle = makeArticle(withTitle: title, abstract: abstract,
                                             byline: byline, url: url, id: id,
                                             publishDate: publishDate,
                                             thumbnailURL: thumbnailURL, largeURL: largeURL) {
                     articles.append(newArticle)
                }
               
            }
            return articles
        }
        return nil
    }
    
}

extension ArticleService {
    
    private func synchronizeFavorite(with article: Article) {
        let id = article.id
        guard let stack = (UIApplication.shared.delegate
            as? AppDelegate)?.coreDataStack else { return }
        
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@", argumentArray: [#keyPath(Article.id), id])
        
        guard let hit = try? stack.persistentContext.fetch(request), let art = hit.first else { return }
        article.isFavorite = art.isFavorite
    }
    
    private func makeArticle(withTitle title: String,
                             abstract: String,
                             byline: String,
                             url: URL?,
                             id: Int64,
                             publishDate: String,
                             thumbnailURL: URL,
                             largeURL: URL ) -> Article? {
        
        if let context = self.context {
            let article = Article(context: context)
            article.title = title
            article.abstract = abstract
            article.byline = byline
            article.url = url
            article.id = id
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date: Date = dateFormatter.date(from: publishDate) {
                article.publishedDate = date as NSDate
            }
            
            article.imageUrl = thumbnailURL
            article.largeImageUrl = largeURL
            
            synchronizeFavorite(with: article)
            return article
        }
        return nil
    }
}
