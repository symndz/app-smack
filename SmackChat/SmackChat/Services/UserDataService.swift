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
    
    func returnUIColor(components: String) -> UIColor {
        // "[0.7255, 0.74902, 0.23529, 1]"
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let separator = CharacterSet(charactersIn: ",")
        
        scanner.charactersToBeSkipped  = skipped
        
        var r, g, b, alpha : NSString?
        
        scanner.scanUpToCharacters(from: separator, into: &r)
        scanner.scanUpToCharacters(from: separator, into: &g)
        scanner.scanUpToCharacters(from: separator, into: &b)
        scanner.scanUpToCharacters(from: separator, into: &alpha)
        
        let defaultColor = UIColor.lightGray
        guard let rUnwrapped = r else { return defaultColor }
        guard let gUnwrapped = g else { return defaultColor }
        guard let bUnwrapped = b else { return defaultColor }
        guard let alphaUnwrapped = alpha else { return defaultColor }
        
        // this because there is no other conversion to CGFloat available
        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let alphaFloat = CGFloat(alphaUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: alphaFloat)
        
        return newUIColor
    }
    
    func logoutUser() {
        id = ""
        avatarName = ""
        avatarColor = ""
        email = ""
        name  = ""
        AuthService.instance.isLoggedIN = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        
        // and also
        MessageService.instance.clearChannels()

        debugPrint("user logged out")
    }

}
