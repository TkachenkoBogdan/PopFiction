//
//  UIViewController+Ext.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/3/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func dismissFavorites() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .reveal 
        transition.subtype = .fromBottom
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: false)
    }

    func embeddedInNavigatioController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}

