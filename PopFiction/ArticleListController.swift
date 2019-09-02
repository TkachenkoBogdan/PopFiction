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
    private let persistantContext = (UIApplication.shared.delegate
        as? AppDelegate)?.coreDataStack.persistentContext
    
    @IBOutlet private var tableView: UITableView?
    
    let service = ArticleService.shared
    var category: ArticleService.ArticleCategory = .mostViewed
    
    var articles = [Article]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
    
           self.tableView?.dataSource = self
           self.tableView?.delegate = self
        
        service.getArticles(for: self.category, completionHandler: { result in
            switch result {
            case .success(let articles):
                self.articles = articles
                
            case .failure:
                print("Failure")
            }
        })
    }
    
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
        // Get current state from data source
        let article = self.articles[indexPath.row]
        let favorite = article.isFavorite
        
        let title = favorite ?
            NSLocalizedString("Unfavorite", comment: "Unfavorite") :
            NSLocalizedString("Favorite", comment: "Favorite")
        
        let action = UIContextualAction(style: .normal, title: title,
                                        handler: { [unowned self] action, view, completionHandler in
                                            // Update data source when user taps action
                                            article.isFavorite = !favorite
         
                                            if article.isFavorite {
                let attKeys = article.entity.attributesByName.keys
                    .map {
                        String($0)
                }
                
                let attributes = article.dictionaryWithValues(forKeys: attKeys)
                
                if let persistantContext = self.persistantContext {
                    let newArticle = Article(context: persistantContext)
                    newArticle.setValuesForKeys(attributes)
                    print(newArticle)
                    
                    guard let coreDataStack = (UIApplication.shared.delegate
                        as? AppDelegate)?.coreDataStack else { return }
                    coreDataStack.saveContext()
                }
                                            } else {
                                               
                                                let request: NSFetchRequest<Article> = Article.fetchRequest()
                                                
                                                request.predicate = NSPredicate(
                                                    format: "%K = %@", argumentArray: [#keyPath(Article.id),article.id])
                                                
                                                if let artToDelete = try? self.persistantContext?.fetch(request).first {
                                                    self.persistantContext?.delete(artToDelete)
                                                }
                                            }
                                            
                                            
                                            completionHandler(true)
        })
        
        action.image = UIImage(named: "heart")
        action.backgroundColor = favorite ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : .green
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    
}
