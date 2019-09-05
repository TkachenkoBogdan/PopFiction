//
//  ArticleService.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/29/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import Foundation
import SwiftyJSON
import Rswift

final class ArticleService {
    
    private let networkService: ArticleNetworkService
    private let dataManager = DataManager.shared
    
    init(networkService: ArticleNetworkService) {
        self.networkService = networkService
    }
    
    func fetchArticles(for category: ArticleCategory = .mostViewed,
                       completionHandler: @escaping (Result<[Article], Error>) -> Void) {
        
        networkService.fetchArticles(forCategory: category) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let articles = self.makeArticles(from: data)
                    completionHandler(Result.success(articles))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                    return
                }
            }
        }
    }
    
    private func makeArticles(from data: Data) -> [Article] {
        var results: [Article] = []
        
        guard let json = try? JSON.init(data: data),
            let topContainer = json["results"].array else { return results }
        
        for article in topContainer {
            let title = article["title"].stringValue
            let abstract = article["abstract"].stringValue
            let byline = article["byline"].stringValue
            let url = article["url"].url
            let id = article["id"].int64Value
            let publishDate = article["published_date"].stringValue
            
            guard let mediaContainer = article["media"].array?.first  else { return results}
            
            guard let thumbnailURLString = mediaContainer["media-metadata"][0]["url"].string,
                let thumbnailURL = URL(string: thumbnailURLString) else { return results }
            
            guard let largeURLString = mediaContainer["media-metadata"][2]["url"].string,
                let largeURL = URL(string: largeURLString) else { return results }
            
            let managedArticle = dataManager.makeArticle(withTitle: title, abstract: abstract,
                                             byline: byline, url: url, id: id,
                                             publishDate: publishDate,
                                             thumbnailURL: thumbnailURL,
                                             largeURL: largeURL)
            results.append(managedArticle)
        }
        return results
    }
}
