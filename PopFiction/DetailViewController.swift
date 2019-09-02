//
//  DetailViewController.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/30/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var urlToLoad: URL?
    @IBOutlet var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = self.urlToLoad else { return }
        let request = URLRequest(url: url)
        webView?.load(request)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
