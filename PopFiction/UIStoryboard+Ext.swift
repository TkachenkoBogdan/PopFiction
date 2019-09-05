//  Created by Богдан Ткаченко on 8/31/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    func instantiateViewController<T: AnyObject>(_ type: T.Type) -> T {
    guard let vc = instantiateViewController(withIdentifier: String(describing: type)) as? T else {
        fatalError("Failed instantiating view controller of type \(type)") }// `}` на отдельной строке
    return vc
  }

  static var main: UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
  }
}

extension UIViewController { //у тебя же есть файл extension для UIViewController лучше этот метод туда поместить

    func embeddedInNavigatioController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
}
