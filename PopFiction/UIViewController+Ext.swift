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
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: false)
    }

}
