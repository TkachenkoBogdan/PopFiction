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

    
    init(with service: ArticleService, category: ArticleCategory) {
        self.service = service
        self.category = category
        super.init()
        fetchArticles(nil)
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
