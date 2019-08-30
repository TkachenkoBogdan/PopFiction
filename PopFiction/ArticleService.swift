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
    }
    
    enum ShareType: String {
        case email, facebook, twitter
    }
    
    public static let shared = ArticleService()
    
    private init() {
    }
    
     func getArticles(for category: ArticleCategory = .mostViewed,
                      completionHandler: @escaping (Result<[Article], Error>) -> Void) {
        var url: URL?
        switch category {
        case .mostEmailed:
            url = URL(string: BASE_URL.appending("/emailed/30.json?api-key=\(API_Key)"))
        case .mostShared(let shareType):
            url = URL(string: BASE_URL.appending("/shared/30/\(shareType.rawValue).json?api-key=\(API_Key)"))
        case .mostViewed:
            url = URL(string: BASE_URL.appending("/viewed/30.json?api-key=\(API_Key)"))
        }
        
//        let urlEmailed = URL(string: BASE_URL.appending("/emailed/30.json?api-key=\(API_Key)"))
//        let urlShared = URL(string: BASE_URL.appending("/shared/30/facebook.json?api-key=\(API_Key)"))
//        let urlViewed = URL(string: BASE_URL.appending("/viewed/30.json?api-key=\(API_Key)"))
       

        //let parameters: Parameters = ["api-key": API_Key]
        
        guard let validURL = url  else { return }
        AF.request(validURL, method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: HEADER).responseJSON { responce in
                   
                    guard responce.error == nil, let data = responce.data else { return }
                    var articlesArray = [Article]()
                    
                    if let json = try? JSON.init(data: data) {
                        guard let articles = json["results"].array else { return }
                        
                        
                        for article in articles {
                            
                            let title = article["title"].string
                            let abstract = article["abstract"].string
                            let byline = article["byline"].string
                            
                            if let context = (UIApplication.shared.delegate
                                as? AppDelegate)?.coreDataStack.managedContext {
                                
                                let article = Article(context: context)
                                article.title = title
                                article.abstract = abstract
                                article.byline = byline
                                
                                articlesArray.append(article)
                            }
                        }
                        completionHandler(Result.success(articlesArray))
                    }
        }
        
    }
    
    
    
    
    
}
