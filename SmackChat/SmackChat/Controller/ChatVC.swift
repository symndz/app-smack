//
//  ChatVC.swift
//  SmackChat
//
//  Created by training on 22.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Outlets
    
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var chanelNameLbl: UILabel!
    @IBOutlet weak var messageTxt: UITextField!
    
    //vars
    var isTyping = false
    
    // Actions
    @IBAction func editingMessage(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChanel?._id else { return }

        if messageTxt.text == "" {
            isTyping = false
            sendBtn.isHidden = true
            
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
        } else {
            if isTyping == false {
                sendBtn.isHidden = false
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
            }
            isTyping = true
        }
    }
    
    @IBAction func sendMsgBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIN {
            guard let channelId = MessageService.instance.selectedChanel?._id else { return }
            guard let message = messageTxt.text else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId) { (success) in
                if success {
                    self.messageTxt.text = ""
                    self.messageTxt.resignFirstResponder()
                    self.sendBtn.isHidden = true
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)

                    debugPrint("DBG succesuly sent message")
                } else {
                    debugPrint("DBG failed to send message")
                }
            }
            
        } else {
            debugPrint("DBG unathorized to send message")
        }
        
    }
    // other
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // little bit of magic
        view.bindToKeyboard()
        
        // tableview datasource and delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        // that gives a table multilines,
        // having a 0 set as number of rows of messageTxt
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // hide send button everytime here
        sendBtn.isHidden = true
        
        // removing that magic keyboard when not needed
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTapOutside))
        view.addGestureRecognizer(tapOutside)
        
        // Do any additional setup after loading the view.
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)

        SocketService.instance.recvMessages { (success) in
            if success {
                self.tableView.reloadData()
                
                // then scroll down to last message
                if MessageService.instance.messages.count > 0 {
                    let endIndexPath = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endIndexPath, at: .bottom, animated: false)
                }
            }
        }

        SocketService.instance.recvTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChanel?._id else { return }
            
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)" // \() is string interpolation
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIN {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typingUsersLbl.text = "\(names) \(verb) typing a message."
            } else {
                self.typingUsersLbl.text = ""
            }
        }
        if AuthService.instance.isLoggedIN {
            AuthService.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
    }
    
    @objc func handleTapOutside() {
        view.endEditing(true)
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIN {
            // get chanels
            onLoginGetMessages()
        } else {
            // please login
            chanelNameLbl.text = "DBG Please Log In"
            tableView.reloadData()
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
        
        debugPrint("DBG id is: \(channelId)")
        MessageService.instance.findAllMessagesForChanel(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
                
                debugPrint("DBG got the messages")
            } else {
                debugPrint("DBG something is not right with messages for \(MessageService.instance.selectedChanel?.name ?? "unknown")")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell" , for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
}
