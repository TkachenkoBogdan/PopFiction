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
     @IBOutlet private var bottomBarView: UIView?
    
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // FIXME: - Refactor this:
        guard let barHeight = self.bottomBarView?.bounds.height else { return }
        let inset = barHeight - (self.view.bounds.height / 40)
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
        tableView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
    }
    
    @IBAction private func segmentedControlChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            self.articles.sort { (art1, art2) -> Bool in
                return (art1.publishedDate as Date) > (art2.publishedDate as Date)
            }
        case 1:
            self.articles.sort { (art1, art2) -> Bool in
                return art1.title < art2.title
            }
        default:
            break
        }
        guard let tableView = tableView else { return }
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: {
                            tableView.reloadData()
        })
    }
    
    @IBAction private func backButtonPressed(_ sender: Any) {
      dismissFavorites()
    }
    
    private func setUp() {
        guard let manager = manager, let favorites = manager.fetchFavorites() else { return }
            self.articles = favorites
            let count = manager.favoritesCount()
                self.navigationItem.title = "Favorites: \(count)"
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
