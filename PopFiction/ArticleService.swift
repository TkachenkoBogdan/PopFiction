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
    
    public static let shared = ArticleService()
    
    
//    ## Example Calls
//    ```
//    https://api.nytimes.com/svc/mostpopular/v2/emailed/7.json?api-key=yourkey
//    ```
//
//    ```
//    https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json?api-key=yourkey
//    ```
//
//    ```
//    https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=yourkey
    
    
    func fetchArticles() {
        let url = URL(string: BASE_URL.appending("/viewed/1.json?api-key=\(API_Key)"))
        let parameters: Parameters = ["api-key": API_Key]
        
        guard let validURL = url  else { return }
        AF.request(validURL, method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: HEADER).responseJSON { responce in
                   
                    guard responce.error == nil, let data = responce.data else { return }
                    
                    if let json = try? JSON.init(data: data) {
                        guard let articles = json["results"].array else { return }
                        guard let firstArticle = articles.first else { return }
                        
                        let title = firstArticle["title"].string
                        let abstract = firstArticle["abstract"].string
                        let byline = firstArticle["byline"].string
                        
                        
                        
                        if let context = (UIApplication.shared.delegate
                            as? AppDelegate)?.persistentContainer.viewContext {
                            
                           let article = Article(context: context)
                            article.title = title
                            article.abstract = abstract
                            article.byline = byline
                            
                        }
                    }
        }
        
    }
    
    
    
    
    
}
