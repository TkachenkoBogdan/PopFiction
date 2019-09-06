//
//  AppDelegate.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/29/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import Foundation

/// Configurations and keys for this app
struct AppConfig {
    /// API key for NYT API:
  static let apiKey = "ZDGO1GbINnwODAofUGwMWYOeKl7GOT76"
    
}

//Notifications:
let favoriteStatusDidChangeNotification = Notification.Name(rawValue: "favoriteStatusDidChange")

extension Notification.Name {
    static let FavoriteStatusDidChange = Notification.Name(rawValue: "favoriteStatusDidChange")
}// Такой подход выглядит более нативным, вообще погугли Notification.Name как использовать там кажется вообще с большой буквы именование

//Notification keys:
    let updateFavoriteStatusKey = "favoriteStatus"
    let updateFavoriteIDKey = "id"
//я против глобальных переменных, я считаю это очень херовым подходом

