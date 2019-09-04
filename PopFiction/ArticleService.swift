//
//  ArticleService.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/29/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import Foundation
import Alamofire
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
    
 
    func loadArticles(for category: ArticleCategory = .mostViewed,
                      completionHandler: @escaping (Result<[Article], Error>) -> Void) {
        
        networkService.fetchArticles(forCategory: category) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let articles = self.parseArticles(from: data) else { return }
                    completionHandler(Result.success(articles))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                    return
                }
            }
        }
    }
    
    private func parseArticles(from data: Data) -> [Article]? {
        if let json = try? JSON.init(data: data) {
            var articles: [Article] = []
            
            guard let topContainer = json["results"].array else { return nil }
            
            for article in topContainer {
                let title = article["title"].string
                let abstract = article["abstract"].string
                let byline = article["byline"].string
                let url = article["url"].url
                let id = article["id"].int64 ?? 0
                let publishDate = article["published_date"].stringValue
                
                guard let mediaContainer = article["media"].array?.first  else { return nil}
                
                guard let stringUrlThumbnail = mediaContainer["media-metadata"][0]["url"].string,
                    let thumbnailUrl = URL(string: stringUrlThumbnail) else { return nil }
        
                guard let stringUrlLarge = mediaContainer["media-metadata"][2]["url"].string,
                    let largeUrl = URL(string: stringUrlLarge) else { return nil}
                
                if let context = self.context {
                    let article = Article(context: context)
                    article.title = title
                    article.abstract = abstract
                    article.byline = byline
                    article.id = id
                    article.url = url
                    article.imageUrl = thumbnailUrl
                    article.largeImageUrl = largeUrl
        
                    // FIXME: - Refactor this:
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date: Date = dateFormatter.date(from: publishDate) {
                    article.publishedDate = date as NSDate
                    }
                    synchronizeFavorite(with: article)
        
                    articles.append(article)
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
    
}
