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


//typealias completionHandler = () -> [String]

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
    }
    
    enum ShareType: String {
        case email, facebook, twitter
    }
    
    public static let shared = ArticleService()
    
    private let context = (UIApplication.shared.delegate
        as? AppDelegate)?.coreDataStack.managedContext
    
    private init() {
    }
    
     func getArticles(for category: ArticleCategory = .mostViewed,
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
        let queue = DispatchQueue(label: "com.test.api",
                                  qos: .background,
                                  attributes: .concurrent)
        
        guard let validURL = url  else { return }
        AF.request(validURL, method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: HEADER).responseJSON(queue: queue) { responce in
                   
                    guard responce.error == nil, let data = responce.data else { return }
                    var articlesArray = [Article]()
                    
                    if let json = try? JSON.init(data: data) {
                        guard let articles = json["results"].array else { return }
                        
                        
                        for article in articles {
                            
                            let title = article["title"].string
                            let abstract = article["abstract"].string
                            let byline = article["byline"].string
                            let url = article["url"].url
                            let id = article["id"].int64 ?? 0
                           
                            guard let mediaContainer = article["media"].array?.first  else { return } //["url"].url
                            guard let mediaInfo = mediaContainer["media-metadata"].first?.1 else { return }
                            guard let imageUrlString = mediaInfo["url"].string,
                                let imageUrl = URL(string: imageUrlString) else { return }
                            if let context = self.context {
                               let article = Article(context: context)
                                article.title = title
                                article.abstract = abstract
                                article.byline = byline
                                article.id = id
                                article.url = url
                                article.imageUrl = imageUrl
                                articlesArray.append(article)
                            }
                        }
                        DispatchQueue.main.async {
                             print(self.context?.insertedObjects.count)
                             completionHandler(Result.success(articlesArray))
                        }
                    }
        }
    }
    
    
    
    
    
}
