//
//  SocketService.swift
//  SmackChat
//
//  Created by training on 30.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    static let instance = SocketService()
    
    override init() { // just for NSObject
        super.init()
        self.socket = manager.defaultSocket
    }
    
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])

    var socket : SocketIOClient!

    func connectSocket(){
        let socket = manager.defaultSocket
        self.manager.config = SocketIOClientConfiguration(
            arrayLiteral: .secure(true))
            socket.connect()
        print("DBG connect")
    }
    
    func disconnectSocket(){
        socket.disconnect()
        print("DBG disconnect")
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        //client.on('newChannel', function(name, description)
        self.socket.emit("newChannel", channelName, channelDescription)
        completion(true)
        print("DBG sending new channel")
    }
    
    func recvChannel(completionStatus: @escaping CompletionHandler) {
        //io.emit("channelCreated", channel.name, channel.description, channel.id);
        self.socket.on("channelCreated") { (dataArrReceived, ack) in
            guard let channelTitle = dataArrReceived[0] as? String else { return }
            guard let channelDesc = dataArrReceived[1] as? String else { return }
            guard let channelID = dataArrReceived[2] as? String else { return }
            print("DBG received CR \(channelTitle) : \(channelDesc) \(channelID)")
            
            //let newChannel = Channel(channelTitle: channelTitle, channelDescription: channelDesc, id: channelID)
            let newChannel = Channel_Swift4(_id: channelID, name: channelTitle, description: channelDesc, __v: 0)
            
            MessageService.instance.channels_Swift4.append(newChannel)
            print("DBG appending new channel \(channelTitle) done")
            completionStatus(true)
        }
    }
    
    //node.js code
    //Listens for a new chat message
    //client.on('newMessage', function(messageBody, userId, channelId, userName, userAvatar, userAvatarColor)
    func addMessage(messageBody: String, userId: String, channelId: String, completionMark: @escaping CompletionHandler) {
        
        let userDataSrvInst = UserDataService.instance
        
        socket.emit("newMessage", messageBody, userId, channelId, userDataSrvInst.name, userDataSrvInst.avatarName, userDataSrvInst.avatarColor)
        
        completionMark(true)
    }
    
    //node.js code
    //Send message to those connected in the room
    //io.emit("messageCreated",  msg.messageBody, msg.userId, msg.channelId, msg.userName, msg.userAvatar, msg.userAvatarColor, msg.id, msg.timeStamp);
    // finally!!
    func recvMessages(completionMark: @escaping CompletionHandler) {
        if AuthService.instance.isLoggedIN == false {
            completionMark(false)
            return
        }
        
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else { return }
            // guard let userId = dataArray[1] -- ignoring this
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            if channelId == MessageService.instance.selectedChanel?._id {
                let newMessage = Message(message: msgBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                MessageService.instance.messages.append(newMessage)
                completionMark(true)
            } else {
                completionMark(false)
            }
        }
    }
    func recvTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else { return }
            completionHandler(typingUsers)
        }
        
    }
}
