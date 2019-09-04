//
//  NetworkService.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/4/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import Foundation
import Alamofire


/// Used to fetch data from network
final class ArticleNetworkService {
    
    private let baseURL = "https://api.nytimes.com/svc/mostpopular/v2"
    private let parameters: Parameters = ["api-key": API_Key]
    
    func fetchArticles(forCategory category: ArticleCategory,
                       completion:  @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = makeURL(forCategory: category) else { return }
        
        let queue = DispatchQueue(label: "com.articleService.fetch",
                                  qos: .background,
                                  attributes: .concurrent)
        
        AF.request(url, method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: HEADER).responseJSON(queue: queue) { responce in
                    
                    guard responce.error == nil, let data = responce.data else {
                        completion(Result.failure(responce.error ?? NSError()))
                        return
                    }
                    completion(Result.success(data))
        }
    }
    
    private func makeURL(forCategory category: ArticleCategory) -> URL? {
        switch category {
        case .mostEmailed:
            return URL(string: baseURL.appending("/emailed/30.json"))
        case .mostShared(let shareType):
            return URL(string: baseURL.appending("/shared/30/\(shareType.rawValue).json"))
        case .mostViewed:
            return URL(string: baseURL.appending("/viewed/30.json"))
        }
    }
    
}
