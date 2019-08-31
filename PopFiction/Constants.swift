//
//  Constants.swift
//  PopFiction
//
//  Created by Богдан Ткаченко on 8/29/19.
//  Copyright © 2019 Богдан Ткаченко. All rights reserved.
//

import Foundation
import Alamofire

typealias CompletionHandler = (_ Success: Bool) -> Void

// NYT API Constants
let BASE_URL = "https://api.nytimes.com/svc/mostpopular/v2"
let API_Key = "ZDGO1GbINnwODAofUGwMWYOeKl7GOT76"

//SB identifiers:
let articleListControllerIdentifier = "articleListNavigationController"

// Cell Identifiers:
let articleCellIdentifier = "articleCell"


// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"


// Headers
let HEADER = HTTPHeaders(["Content-Type": "application/json; charset=utf-8"]) 

//let BEARER_HEADER = [
//    "Authorization":"Bearer \(AuthService.instance.authToken)",
//    "Content-Type": "application/json; charset=utf-8"
//]
