//
//  AuthService.swift
//  SmackChat
//
//  Created by training on 24.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {

    static let instance = AuthService() // initialize this as singleton here

    let defaults = UserDefaults.standard // builtin feature
    
    var isLoggedIN : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }

    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER_JSON_TYPE).responseString { (response) in
            if response.result.error == nil {
                completion(true)
                debugPrint(response.result.value as Any)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOG_IN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER_JSON_TYPE).responseJSON
            { (response) in
                if response.result.error == nil {
                    // method 1 to handle JSON values
//                    if let json = response.result.value as? Dictionary<String, Any> {
//                        if let email = json["user"] as? String {
//                            self.userEmail = email
//                        }
//                        if let token = json["token"] as? String {
//                            self.authToken = token
//                        }
//
//                    }
                    
                    // method 2 to handle JSON values
                    // using swiftyJSON

                    guard let data = response.data else { return }
                    
                    do {
                        let json = try JSON(data: data)
                        self.userEmail = json["user"].stringValue
                        self.authToken = json["token"].stringValue
                    } catch let error as NSError {
                        debugPrint(error)
                    }
                    
                    self.isLoggedIN = true
                    completion(true)
                    debugPrint(response.result.value as Any)
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
        }
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER_AUTH_TYPE_WITH_TOKEN).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.setUserINfo(data: data)
                debugPrint(response.result.value as Any)
                completion(true)
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
            
            
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER_AUTH_TYPE_WITH_TOKEN).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                
                if self.setUserINfo(data: data) {
                    completion(true)
                    debugPrint(response.result.value as Any)
                } else {
                    completion(false)
                    debugPrint("unknown auth error")
                }


            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func setUserINfo(data: Data) -> Bool {
        do {
            let json = try JSON(data: data)
            
            let id = json["_id"].stringValue
            let avatarColor = json["avatarColor"].stringValue
            let avatarName = json["avatarName"].stringValue
            let email = json["email"].stringValue
            let name = json["name"].stringValue
    
            
            UserDataService.instance.setUserData(id: id, avatarColor: avatarColor, avatarName: avatarName, email: email, name: name)
            return true
            
        } catch let error as NSError {
            debugPrint(error)
            return false
        }
    
        
    }
    
}
