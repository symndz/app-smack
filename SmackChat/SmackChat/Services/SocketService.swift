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
}
