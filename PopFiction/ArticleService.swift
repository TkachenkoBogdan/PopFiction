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
    
    enum ArticleCategory {
        case mostEmailed, mostShared(ShareType), mostViewed
        
        var title: String {
            switch self {
            case .mostEmailed:
                return "Most Emailed"
            case .mostShared:
                return "Most Shared"
            case .mostViewed:
                return "Most Viewed"
            }
        }
        
        var image: UIImage {
            var image: UIImage?
                switch self {
                case .mostEmailed:
                    image = R.image.emailed()
                case .mostShared:
                    image = R.image.shared()
                case .mostViewed:
                    image = R.image.viewed()
                }
            return image ?? UIImage()
        }
    }
    
    enum ShareType: String {
        case email, facebook, twitter
    }
    
    public static let shared = ArticleService()
    
    private let context = (UIApplication.shared.delegate
        as? AppDelegate)?.coreDataStack.managedContext
    
    private init() {
    }
    
    func loadArticles(for category: ArticleCategory = .mostViewed,
                      completionHandler: @escaping (Result<[Article], Error>) -> Void) {
        var url: URL?
        
        switch category {
        case .mostEmailed:
            url = URL(string: BASE_URL.appending("/emailed/30.json"))
        case .mostShared(let shareType):
            url = URL(string: BASE_URL.appending("/shared/30/\(shareType.rawValue).json"))
        case .mostViewed:
            url = URL(string: BASE_URL.appending("/viewed/30.json"))
        }
        
        let parameters: Parameters = ["api-key": API_Key]
        let queue = DispatchQueue(label: "com.articleService.fetch",
                                  qos: .background,
                                  attributes: .concurrent)
        
        guard let validURL = url  else { return }
        AF.request(validURL, method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: HEADER).responseJSON(queue: queue) { responce in
                    
                    guard responce.error == nil, let data = responce.data else {
                        completionHandler(Result.failure(responce.error ?? NSError()))
                        return
                    }
                    
                    DispatchQueue.main.async {
                        guard let articlesArray = self.parseArticles(from: data) else { return }
                        completionHandler(Result.success(articlesArray))
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
    
    func synchronizeFavorite(with article: Article) {
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
