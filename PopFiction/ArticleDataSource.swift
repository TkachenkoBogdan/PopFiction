//
//  ArticleDataSource.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/2/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit

final class ArticleDataSource: NSObject, UITableViewDataSource {
    
    typealias OnFetchedCompletion = ((Bool) -> Void)
    
    private let service: ArticleService
    private let category: ArticleCategory
    var onUpdateCompletion: ((Bool) -> Void)?
   // private var token: NSObjectProtocol

    
    init(with service: ArticleService, category: ArticleCategory) {
        self.service = service
        self.category = category
        super.init()
        fetchArticles(nil)
       NotificationCenter.default.addObserver(self,
                                              selector: #selector(refreshArticles),
                                               name: favoriteStatusDidChangeNotification,
                                               object: nil)
    }
    
    @objc func refreshArticles(notification: Notification) {
        if let id = notification.userInfo?["idChanged"] as? Int64,
            let isFavorite = notification.userInfo?["newValue"] as? Bool {
             let art = self.articles.first { $0.id == id }
            guard let article = art else { return }
            article.isFavorite = isFavorite
            onUpdateCompletion?(true)
        }
        
    }
    
    private(set) var articles = [Article]() {
        didSet {
            onUpdateCompletion?(true)
        }
    }
    
    func fetchArticles(_ completion: OnFetchedCompletion?) {
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
    
    // MARK: - TableViewDataSource:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: R.reuseIdentifier.articleCell.identifier,
            for: indexPath) as? ArticleCell else { return UITableViewCell() }
        
        let article = articles[indexPath.row]
        cell.configureWith(article: article)
        return cell
    }
}
