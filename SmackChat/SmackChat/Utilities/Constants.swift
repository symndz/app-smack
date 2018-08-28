//
//  Constants.swift
//  SmackChat
//
//  Created by training on 23.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> () // enclosure or closure

// URL Constants

let BASE_URL = "https://chattychatvhatv2.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOG_IN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)channel"

// Segues

let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"


// Colors

let smackPurplePlaceholder = #colorLiteral(red: 0.3631127477, green: 0.4045833051, blue: 0.8775706887, alpha: 1)

// Notifications

let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")

// User Defaults

let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Headers

let HEADER_JSON_TYPE = [
    "Content-Type" : "application/json; characterset=utf-8"
]

let HEADER_AUTH_TYPE_WITH_TOKEN = [
    "Authorization" : "Bearer \(AuthService.instance.authToken)",
    "Content-Type" : "application/json; characterset=utf-8"
]




