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

let BASE_URL = "http://chattychatvhatv2.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"

// Segues

let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"


// User Defaults

let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
