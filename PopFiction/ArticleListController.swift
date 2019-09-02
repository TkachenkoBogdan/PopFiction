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
    
    private let service = ArticleService.shared
    var category: ArticleService.ArticleCategory = .mostViewed
    
    private var articles = [Article]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    // MARK: - Lifecycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
           self.tableView?.dataSource = self
           self.tableView?.delegate = self
        
        fetchArticles()
    }

}

// MARK: - Helpers:
extension ArticleListController {
    private func fetchArticles() {
        service.getArticles(for: self.category, completionHandler: { result in
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure:
                print("Failure to fetch articles :(")
            }
        })
    }
    
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
        
        let article = self.articles[self.tableView?.indexPathForSelectedRow?.row ?? 0]
        guard let url = article.url else { return }
        
        destination.urlToLoad = url
    }
}




// MARK: - UITableViewDataSource:
extension ArticleListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: articleCellIdentifier, for: indexPath) as? ArticleCell else { return UITableViewCell() }
        
        let article = articles[indexPath.row]
        cell.configureWith(article: article)
        return cell
    }
}

// MARK: - UITableViewDelegate:
extension ArticleListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = self.articles[indexPath.row]
        if let url = article.url {
            UIApplication.shared.open(url) { _ in
                print("opened URL: \(url)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let article = self.articles[indexPath.row]
        
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
