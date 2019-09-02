//
//  ArticleDataSource.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/2/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit

class ArticleDataSource: NSObject, UITableViewDataSource {
    
    init(withCategory category: ArticleService.ArticleCategory) {
        super.init()

        ArticleService.shared.loadArticles(for: category, completionHandler: { result in
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure:
                print("Failure to fetch articles :(")
            }
        })
    }
    var articles = [Article]() {
        didSet {
            NotificationCenter.default.post(name: dataSourceDidChangeNotification, object: self)
        }

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
