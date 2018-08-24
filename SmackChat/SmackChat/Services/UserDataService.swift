//
//  UserDataService.swift
//  SmackChat
//
//  Created by training on 24.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import Foundation


class UserDataService {
    
    // singleton
    static let instance = UserDataService()
    
    public private(set) var id = "" // !!! other classes can look at public but cannot private-set lock
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, avatarColor: String, avatarName: String, email: String, name: String) {
        setId(id: id)
        setAvatarColor(avatarColor: avatarColor)
        setAvatarName(avatarName: avatarName)
        self.email = email
        self.name = name
    }

    func setId(id: String) {
        self.id = id
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    func setAvatarColor(avatarColor: String) {
        self.avatarColor = avatarColor
    }

}
