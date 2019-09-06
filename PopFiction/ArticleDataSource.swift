//
//  ArticleDataSource.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/2/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit

final class ArticleDataSource: NSObject, UITableViewDataSource {
    
    typealias CompletionHandler = ((Bool) -> Void)
    
    private let service: ArticleService
    private let category: ArticleCategory
    var onUpdateCompletion: ((IndexPath) -> Void)?
    var onFetchCompletion: CompletionHandler?

    init(with service: ArticleService, category: ArticleCategory) {
        self.service = service
        self.category = category
        super.init()
        
        fetchArticles(nil)
        registerFavoriteUpdateNotification()
    }
    
    private(set) var articles = [Article]() {
        didSet {
            onFetchCompletion?(true)
        }
    }
    
    // MARK: - TableViewDataSource:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: R.reuseIdentifier.articleCell.identifier,
            for: indexPath) as? ArticleCell else { return UITableViewCell() }
        
        cell.configureWith(article: articles[indexPath.row])
        return cell
    }
 
}

extension ArticleDataSource {
    func fetchArticles(_ completion: CompletionHandler?) {
        service.fetchArticles(for: self.category, completionHandler: { result in
            switch result {
            case .success(let articles):
                self.articles = articles
                completion?(true)
            case .failure:
                print("Failed to fetch articles.")
                completion?(false)
            }
        })
    }
    
    // MARK: - Favorite Status Update Notifications::
    @objc private func refreshArticles(notification: Notification) {
        guard let id = notification.userInfo?[DataManager.Keys.updateFavoriteIDKey] as? Int64,
            let isFavorite = notification.userInfo?[DataManager.Keys.updateFavoriteStatusKey] as? Bool else { return }
        
        if let article = self.articles.first(where: { $0.id == id }) {
            article.isFavorite = isFavorite
            
            if let index = self.articles.indexDistance(of: article) {
                let indexPath = IndexPath(row: index, section: 0)
                onUpdateCompletion?(indexPath)
            } 
        }
    }
    private func registerFavoriteUpdateNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshArticles),
                                               name: .FavoriteStatusDidChange,
                                               object: nil)
    }
}


extension Collection where Element: Equatable {
    func indexDistance(of element: Element) -> Int? {
        guard let index = firstIndex(of: element) else { return nil }
        return distance(from: startIndex, to: index)
    }
}
