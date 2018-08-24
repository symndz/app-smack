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

let HEADER_JSON_TYPE = [
    "Content-Type" : "application/json; characterset=utf-8"
]

let HEADER_AUTH_TYPE_WITH_TOKEN = [
    "Authorization" : "Bearer \(AuthService.instance.authToken)"
]




