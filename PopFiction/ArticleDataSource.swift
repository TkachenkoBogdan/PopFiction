//
//  ArticleDataSource.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/2/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit

class ArticleDataSource: NSObject, UITableViewDataSource {
    
    typealias Completion = ( (Bool) -> Void )
    private let category: ArticleCategory
    
    init(withCategory category: ArticleCategory) {
        self.category = category
        super.init()
        fetchArticles(nil)
    }
    
    private(set) var articles = [Article]() {
        didSet {
            NotificationCenter.default.post(name: dataSourceDidChangeNotification, object: self)
        }
    }
    
    func fetchArticles(_ completion: Completion?) {
        ArticleService.shared.loadArticles(for: self.category, completionHandler: { result in
            switch result {
            case .success(let articles):
                self.articles = articles
                completion?(true)
            case .failure:
                print("Failure to fetch articles :(")
                 completion?(false)
            }
        })
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return articles.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: articleCellIdentifier, for: indexPath) as? ArticleCell else { return UITableViewCell() }
            
            let article = articles[indexPath.row]
            cell.configureWith(article: article)
            return cell
        }
}
