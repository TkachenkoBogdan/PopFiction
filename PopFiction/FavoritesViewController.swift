//
//  FavoritesViewController.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/2/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    var manager: DataManager?
    
    @IBOutlet private var tableView: UITableView!
    
    var articles: [Article] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

   
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        if let manager = manager {
            self.articles = manager.fetchFavorites()
        }

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
      dismissFavorites()
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: R.reuseIdentifier.favoritesCell.identifier,
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
