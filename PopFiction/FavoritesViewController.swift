//
//  FavoritesViewController.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/2/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    private let persistentContext = (UIApplication.shared.delegate
        as? AppDelegate)?.coreDataStack.persistentContext
    
    var fetchRequest: NSFetchRequest<Article>?
    var articles: [Article] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        fetchRequest = Article.fetchRequest()
        
        guard let request = fetchRequest,
            let persistentContext = persistentContext else { return }
        if let articles = try? persistentContext.fetch(request) {
            self.articles = articles
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: favoritesArticleCellIdentifier,
            for: indexPath) as? ArticleCell else { return UITableViewCell() }
        
        let article = articles[indexPath.row]
        cell.configureWith(article: article)
        return cell
    }
}

// MARK: - UITableViewDelegate:
extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = self.articles[indexPath.row]
        if let url = article.url {
            UIApplication.shared.open(url) { _ in
                print("opened URL: \(url)")
            }
        }
    }
    
}
