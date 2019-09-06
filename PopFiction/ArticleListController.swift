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
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showRefreshView()
    }
    
}

// MARK: - UITableViewDelegate:
extension ArticleListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = self.dataSource?.articles[indexPath.row].url else { return }
            UIApplication.shared.open(url)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let article = self.dataSource?.articles[indexPath.row],
              let manager = self.manager else { return nil }

        let action = UIContextualAction(style: .normal, title: title,
                                        handler: { [unowned self] _, _, handler in
                article.isFavorite.toggle()
                self.tableView?.reloadRows(at: [indexPath], with: .none)
                
                if article.isFavorite {
                    manager.makeFavorite(article)
                } else {
                    manager.makeUnfavorite(article: article.id)
                }
                handler(true)
        })
        
        action.image = R.image.heart_empty()
        action.backgroundColor = article.isFavorite
            ? R.color.unfavorite()
            : R.color.favorite()
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}

// MARK: - Navigation:
extension ArticleListController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == R.segue.articleListController.toFavorites.identifier,
            let navController = segue.destination as? UINavigationController,
            let destination = navController.topViewController as? FavoritesViewController
            else { return }
        destination.manager = self.manager
    }
}

// MARK: - Helpers:
extension ArticleListController {
    
    @objc private func refreshData(_ sender: Any) {
        self.refreshButton?.fadeTransition(withDuration: 0.7)
        self.refreshButton?.alpha = 0
        
        dataSource?.fetchArticles { success in
            DispatchQueue.main.async {
                self.control.endRefreshing()
                if !success {
                    UIView.animate(withDuration: 2, animations: {
                        self.refreshButton?.alpha = 1
                    })
                }
            }
        }
    }
    
    private var isDataSourceEmpty: Bool {
        guard let dataSource = self.dataSource else { return true }
        return dataSource.articles.isEmpty ? true : false
    }
    
    
    private func showRefreshView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
            if self.isDataSourceEmpty {
                self.refreshButton?.fadeTransition(withDuration: 0.8)
                self.refreshButton?.isHidden = false
            }
        }
    }
    
    private func setUp() {
        guard let tableView = self.tableView else { return }
        self.dataSource?.onUpdateCompletion = { indexPath in
            UIView.performWithoutAnimation {
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
        self.dataSource?.onFetchCompletion = { _ in
            UIView.transition(with: tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: {
                                tableView.isHidden = false
                                tableView.reloadData()
            })
        }

        control.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshButton?.addTarget(self, action: #selector(refreshData(_:)), for: .touchUpInside)
        
        tableView.refreshControl = control
        tableView.isHidden = isDataSourceEmpty
        
        tableView.dataSource = self.dataSource
        tableView.delegate = self
        
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = true
    }
}
