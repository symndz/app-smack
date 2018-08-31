//
//  MessageService.swift
//  SmackChat
//
//  Created by training on 28.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService() //singleton :)
    
    //var channels = [Channel]() // () makes instance
    //    func findAllChannel(completion: @escaping CompletionHandler) {
    //        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER_AUTH_TYPE_WITH_TOKEN).responseJSON { (response) in
    //            if response.result.error == nil {
    //                guard let data = response.data else { return }
    //
    //                do {
    //                    if let json = try JSON(data: data).array {
    //                    for item in json {
    //                        let name = item["name"].stringValue
    //                        let channelDescription = item["description"].stringValue
    //                        let id = item["_id"].stringValue
    //
    //                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
    //                        self.channels.append(channel)
    //                        completion(true)
    //                    }
    //                }
    //                } catch let error as NSError {
    //                        debugPrint(error)
    //                        completion(false)
    //                }
    //
    //            } else {
    //                completion(false)
    //                debugPrint(response.result.error as Any)
    //            }
    //
    //        }
    //    }
    
    var channels_Swift4 = [Channel_Swift4]() // () make instance
    var messages = [Message]()
    var unreadChannels = [String]()
    var selectedChanel : Channel_Swift4?

    func findAllChannel_Swift4(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER_AUTH_JUST_TOKEN).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                do {
                    self.channels_Swift4 = try JSONDecoder().decode([Channel_Swift4].self, from: data)
                    // let the know channel list view via notification
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LIST_CHANGE, object: nil)
                    completion(true)
                } catch let error {
                    debugPrint(error as Any)
                    completion(false)
                }
                
                print(self.channels_Swift4)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels_Swift4.removeAll()
    }
    
    func findAllMessagesForChanel(channelId: String, completionMark: @escaping CompletionHandler) {
        debugPrint("DBG URL \(URL_GET_MESSAGES)\(channelId)")
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER_AUTH_JUST_TOKEN).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else { return }
                debugPrint("DBG almost ready to parse")
                do {
                    if let json = try JSON(data: data).array {
                        for item in json {
                            let messageBody = item["messageBody"].stringValue
                            let channelId = item["channelId"].stringValue
                            let id = item["_id"].stringValue
                            let userName = item["userName"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColor = item["userAvatarColor"].stringValue
                            let timeStamp = item["timeStamp"].stringValue
                            
                            let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                            
                            self.messages.append(message)
                        }
                    }
                } catch let error {
                        debugPrint(error as Any)
                        completionMark(false)
                }
                print("DBG messages comes next")
                print(self.messages)
                completionMark(true)
            } else {
                debugPrint(response.result.error as Any)
                completionMark(false)
            }
        }
    }
}
