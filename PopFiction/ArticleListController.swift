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
   
    private let coreDataStack = (UIApplication.shared.delegate
        as? AppDelegate)?.coreDataStack
    
    @IBOutlet private var tableView: UITableView?
    
    var dataSource: ArticleDataSource?
    var notificationToken: NSObjectProtocol?
    let control = UIRefreshControl()
    
    // MARK: - Lifecycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
           control.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
           self.tableView?.refreshControl = control
            
           self.tableView?.dataSource = self.dataSource
           self.tableView?.delegate = self
    }
    
    @objc private func refreshData(_ sender: Any) {
        dataSource?.fetchArticles { success in
            DispatchQueue.main.async {
                if success {
                    self.tableView?.reloadData()
                }
                // FIXME: - Add popup with alert message:
                
                self.control.endRefreshing()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notificationToken = NotificationCenter.default.addObserver(forName: dataSourceDidChangeNotification,
                                               object: dataSource,
                                               queue: nil) { [weak self] _ in
            self?.tableView?.reloadData()
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
