//
//  UIView+Extension.swift
//  Baller
//
//  Created by Богдан Ткаченко on 8/23/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit

extension UIView {
    func fadeTransition(withDuration duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 40, y: 0)
        UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 2.2,
                       options: .curveLinear,
                       animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    
}
