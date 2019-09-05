//
//  ArticleListControllerViewController.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/31/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit

final class ArticleListController: UIViewController {
   
    var manager: DataManager?
    var dataSource: ArticleDataSource?
    
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private var refreshButton: UIButton?
    
    private let control = UIRefreshControl()
    private var notificationToken: NSObjectProtocol?
   
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        self.dataSource?.onUpdateCompletion = { [unowned self] _ in
            guard let tableView = self.tableView else { return }
            UIView.transition(with: tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: {
                                tableView.isHidden = false
                                tableView.reloadData()
            })
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.refreshButton?.fadeTransition(withDuration: 0.7)
        self.refreshButton?.alpha = 0
        
        dataSource?.fetchArticles { _ in
            DispatchQueue.main.async {
                self.control.endRefreshing()
                UIView.animate(withDuration: 2, animations: {
                    self.refreshButton?.alpha = 1
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [unowned self] in
            if self.isDataSourceEmpty {
                self.refreshButton?.fadeTransition(withDuration: 0.8)
                self.refreshButton?.isHidden = false
            }
        }
    }
}

// MARK: - Navigation:
extension ArticleListController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == R.segue.articleListController.toFavorites.identifier,
        let nav = segue.destination as? UINavigationController,
            let destination = nav.topViewController as? FavoritesViewController
            else { return }
        destination.manager = self.manager
    }
}

// MARK: - Helpers:

extension ArticleListController {
    private var isDataSourceEmpty: Bool {
        guard let dataSource = self.dataSource else { return true }
        return dataSource.articles.isEmpty ? true : false
    }
    private func setUp() {
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = true
        
        control.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshButton?.addTarget(self, action: #selector(refreshData(_:)), for: .touchUpInside)
        
        self.tableView?.refreshControl = control
        tableView?.isHidden = isDataSourceEmpty
        
        self.tableView?.dataSource = self.dataSource
        self.tableView?.delegate = self
    }
}

// MARK: - UITableViewDelegate:
extension ArticleListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = self.dataSource?.articles[indexPath.row] else { return }
        if let url = article.url {
            UIApplication.shared.open(url)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let article = self.dataSource?.articles[indexPath.row] else { return nil }
        guard let manager = self.manager else { return nil }
        
        let action = UIContextualAction(style: .normal, title: title,
                                        handler: { [unowned self] _, _, completionHandler in
            article.isFavorite.toggle()
            self.tableView?.reloadRows(at: [indexPath], with: .none)
            if article.isFavorite {
                manager.setFavorite(article)
            } else {
                manager.deleteArticle(withID: article.id)
            }
            completionHandler(true)
        })
        
        action.image = R.image.heart_empty()
        action.backgroundColor = article.isFavorite
            ? R.color.unfavorite()
            : R.color.favorite()
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}
