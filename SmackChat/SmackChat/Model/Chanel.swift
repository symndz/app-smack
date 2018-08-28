//
//  Chanel.swift
//  SmackChat
//
//  Created by training on 28.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import Foundation

struct Channel {
    public private(set) var channelTitle: String!
    public private(set) var channelDescription: String!
    public private(set) var id: String!
    
}

struct Channel_Swift4 : Decodable {
    public private(set) var _id: String!
    public private(set) var name: String!
    public private(set) var description: String!
    public private(set) var __v: Int!
}
