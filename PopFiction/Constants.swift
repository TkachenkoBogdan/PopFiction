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

// URL Constants
let BASE_URL = "https://api.nytimes.com/svc/mostpopular/v2"
let API_Key = "ZDGO1GbINnwODAofUGwMWYOeKl7GOT76"

//let URL_REGISTER = "\(BASE_URL)account/register"
//let URL_LOGIN = "\(BASE_URL)account/login"
//let URL_USER_ADD = "\(BASE_URL)user/add"
//let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
//let URL_GET_CHANNELS = "\(BASE_URL)channel/"


// Notification Constants
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")

// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Headers
let HEADER = HTTPHeaders(["Content-Type": "application/json; charset=utf-8"]) 

//let BEARER_HEADER = [
//    "Authorization":"Bearer \(AuthService.instance.authToken)",
//    "Content-Type": "application/json; charset=utf-8"
//]
