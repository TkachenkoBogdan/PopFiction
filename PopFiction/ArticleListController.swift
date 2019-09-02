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
    
    // MARK: - Lifecycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
           self.tableView?.dataSource = self.dataSource
           self.tableView?.delegate = self
        
       // fetchArticles()
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

// MARK: - Navigation:
extension ArticleListController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard "toDetailVC" == segue.identifier,
            let destination = segue.destination as? DetailViewController else { return }
        
        guard let article = self.dataSource?.articles[self.tableView?.indexPathForSelectedRow?.row ?? 0],
            let url = article.url else { return }
        
        destination.urlToLoad = url
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
            if article.isFavorite {
                self.setFavorite(article)
            } else {
               self.deleteArticle(withID: article.id)
            }
            completionHandler(true)
        })
        
        action.image = UIImage(named: "heart")
        action.backgroundColor = article.isFavorite ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : .green
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}
