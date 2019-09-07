//
//  Date.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 9/7/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import Foundation

extension Date {
     func toString(withStyle style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self )
    }
}
