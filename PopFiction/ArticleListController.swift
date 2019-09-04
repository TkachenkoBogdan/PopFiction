//
//  ArticleListControllerViewController.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/31/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit
import CoreData

class ArticleListController: UIViewController {
   
    var coreDataStack: CoreDataStack?
    var dataSource: ArticleDataSource?
    
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private var refreshButton: UIButton?
    
    let control = UIRefreshControl()
   
    var notificationToken: NSObjectProtocol?
   
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        control.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshButton?.addTarget(self, action: #selector(refreshData(_:)), for: .touchUpInside)
        
           self.tableView?.refreshControl = control
        
           self.navigationController?.navigationBar.barTintColor = .clear
           self.navigationController?.navigationBar.barStyle = .black
           self.navigationController?.navigationBar.isTranslucent = true
        
           self.tableView?.dataSource = self.dataSource
           self.tableView?.delegate = self
        
        guard let dataSource = self.dataSource else { return }
        tableView?.isHidden = dataSource.articles.isEmpty ? true : false

    }
    
    @objc private func refreshData(_ sender: Any) {
        self.refreshButton?.fadeTransition(withDuration: 0.7)
        self.refreshButton?.alpha = 0
        
        dataSource?.fetchArticles { success in
            DispatchQueue.main.async {
                self.control.endRefreshing()
                UIView.animate(withDuration: 2, animations: {
                    self.refreshButton?.alpha = 1
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notificationToken = NotificationCenter.default.addObserver(forName: dataSourceDidChangeNotification,
                                               object: dataSource,
                                               queue: nil) { [unowned self] _ in
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
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken = nil
    }

}

// MARK: - Helpers:
extension ArticleListController {

    
    private func setFavorite(_ article: Article) {
        let attKeys = article.entity.attributesByName.keys
            .map {
                String($0)
        }
        
        let attributes = article.dictionaryWithValues(forKeys: attKeys)
        
        if let persistantContext = self.coreDataStack?.persistentContext {
            let newArticle = Article(context: persistantContext)
            newArticle.setValuesForKeys(attributes)
            print(newArticle)
            
            guard let coreDataStack = (UIApplication.shared.delegate
                as? AppDelegate)?.coreDataStack else { return }
            coreDataStack.saveContext()
        }
    }
    
    private func deleteArticle(withID id: Int64) {
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@", argumentArray: [#keyPath(Article.id), id])
        
        if let artToDelete = try? self.coreDataStack?.persistentContext.fetch(request).first,
            let coreDataStack = coreDataStack {
            coreDataStack.persistentContext.delete(artToDelete)
            coreDataStack.saveContext()
        }
    }
}

// MARK: - UITableViewDelegate:
extension ArticleListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = self.dataSource?.articles[indexPath.row] else { return }
        if let url = article.url {
            UIApplication.shared.open(url) { _ in
                print("opened URL: \(url)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let article = self.dataSource?.articles[indexPath.row] else { return nil }
        
        let title = article.isFavorite ? "Unfavorite": "Favorite"
        
        let action = UIContextualAction(style: .normal, title: title,
                                        handler: { [unowned self] _, _, completionHandler in
            article.isFavorite.toggle()
            self.tableView?.reloadRows(at: [indexPath], with: .automatic)
            if article.isFavorite {
                self.setFavorite(article)
            } else {
               self.deleteArticle(withID: article.id)
            }
            completionHandler(true)
        })
        
        action.image = UIImage(named: "heart")
        action.backgroundColor = article.isFavorite ? unfavoriteColor : favoriteColor
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}
