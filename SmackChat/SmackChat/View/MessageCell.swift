//
//  MessageCell.swift
//  SmackChat
//
//  Created by training on 30.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    // Outlets
    
    @IBOutlet weak var messageBodyLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImg: CircleImage!
    // Actions
    
    // the rest or code
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(message: Message) {
        messageBodyLbl.text = message.message
        userNameLbl.text = message.userName
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        // timedate for later
    }

}
