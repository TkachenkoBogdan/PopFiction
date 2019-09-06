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
            self.navigationItem.title = "Favorites: \(articles.count)"
        }
    }
    
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private var bottomBarView: UIView?
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        adjustInsets()
    }
    
    @IBAction private func segmentedControlChanged(_ segmentedControl: UISegmentedControl) {
       sort(by: segmentedControl.selectedSegmentIndex)
        
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
}

// MARK: - Helpers:
extension FavoritesViewController {
    private func sort(by index: Int) {
        switch index {
        case 0:
            self.articles.sort { ($0.publishedDate as Date) > ($1.publishedDate as Date) }
        case 1:
            self.articles.sort { $0.title < $1.title }
        default: break
        }
    }
    
    private func adjustInsets() {
        guard let barHeight = self.bottomBarView?.bounds.height else { return }
        let inset = barHeight - (self.view.bounds.height / 45 - 10)
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
        tableView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
    }
    
    private func setUp() {
        guard let manager = manager, let favorites = manager.fetchFavorites() else { return }
        self.articles = favorites
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
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
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let article = self.articles[indexPath.row]
        guard let manager = self.manager else { return nil }
    
        let action = UIContextualAction(style: .normal, title: title,
                                        handler: { [unowned self] _, _, handler in
                                            
                                            article.isFavorite.toggle()
                                            manager.makeUnfavorite(article: article.id)
                                            
                                            self.tableView?.beginUpdates()
                                            self.articles.remove(at: indexPath.row)
                                            self.tableView?.deleteRows(at: [indexPath], with: .none)
                                            self.tableView?.endUpdates()
                                    
                                            handler(true)
        })
        
        action.image = R.image.heart_empty()
        action.backgroundColor = R.color.unfavorite()
    
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
}
