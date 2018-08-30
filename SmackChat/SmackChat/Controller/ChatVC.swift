//
//  ChatVC.swift
//  SmackChat
//
//  Created by training on 22.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    //Outlets
    
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var chanelNameLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)

        if AuthService.instance.isLoggedIN {
            AuthService.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIN {
            // get chanels
            onLoginGetMessages()
        } else {
            // please login
            chanelNameLbl.text = "Please Log In"
        }
    }

    @objc func channelSelected(_ notif: Notification) {
        updateViewWithChannel()
    }

    func updateViewWithChannel() {
        let channelName = MessageService.instance.selectedChanel?.name ?? ""
        chanelNameLbl.text = "#\(channelName)"
        getMessages()
    }

    func onLoginGetMessages() {
        MessageService.instance.findAllChannel_Swift4 { (success) in
            if success {
                // do stuff with channels
                if MessageService.instance.channels_Swift4.count > 0 {
                    MessageService.instance.selectedChanel = MessageService.instance.channels_Swift4[0]
                    self.updateViewWithChannel()
                    debugPrint("DBG channel view done")
                } else {
                    self.chanelNameLbl.text = "No channels yet!"
                    debugPrint("DBG no channels made")
                }
                print("DBG manage chanels from DB")
            }
        }
    }

    func getMessages() {
        guard let channelId = MessageService.instance.selectedChanel?._id else { return }
        
        MessageService.instance.findAllMessagesForChanel(channelId: channelId) { (success) in
            if success {
                debugPrint("DBG got the messages")
            }
        }
    }
}
