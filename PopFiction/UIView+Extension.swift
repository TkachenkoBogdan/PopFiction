//
//  UIView+Extension.swift
//  Baller
//
//  Created by Богдан Ткаченко on 8/23/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import UIKit
// Лучше назови папку `Extensions` а файлы просто `UIView` / `UIViewController`, etc.
extension UIView {
    func fadeTransition(withDuration duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)// здесь не нужен перенос строки
        animation.type = CATransitionType.fade// здесь можно просто `.fade` использовать
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
