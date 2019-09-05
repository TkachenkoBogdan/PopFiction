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
   
    
    private var articles: [Article] = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
     @IBOutlet private var tableView: UITableView?
     @IBOutlet private var favoritesCount: UILabel?
    
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        setUp()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
      dismissFavorites()
    }
    
    private func setUp() {
        if let manager = manager {
            self.articles = manager.fetchFavorites()
            let count = manager.favoritesCount()
            favoritesCount?.text = "Favorites Count: \(count)"
        }
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
        if let url = self.articles[indexPath.row].url {
            UIApplication.shared.open(url)
        }
    }
    
}
