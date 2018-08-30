//
//  ChannelVC.swift
//  SmackChat
//
//  Created by training on 22.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // Outlets section
    
    @IBOutlet weak var userImage: CircleImage!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    // Actions section
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    @IBAction func addChannelPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIN {
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        } else {
            debugPrint("DBG not authorized to add ")
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIN {
            // show profile page
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    override func viewDidLoad() {
        debugPrint("DBG ChannelVC vied did load")
        
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        self.revealViewController().rearViewRevealWidth =
            self.view.frame.size.width - 60
        
        // adding notification observer (NOTIF_USER_DATA_DID_CHANGE)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        // adding notification observer (NOTIF_CHANNELS_LIST_CHANGE)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userChannelsListChanged(_:)), name: NOTIF_CHANNELS_LIST_CHANGE, object: nil)
        
        
        // get channels list
        MessageService.instance.findAllChannel_Swift4 { (success) in
            debugPrint("DBG here we go")
        }
        
        // get from socket or listen to?
        SocketService.instance.recvChannel { (success) in
            if success {
                self.tableView.reloadData()
                debugPrint("DBG reloading new data")
            } else {
                debugPrint("DBG failed to receive something")
            }
        }
    }

    @objc func userDataDidChange(_ notif: Notification) {
        setupUserInfo()
    }
    
    @objc func userChannelsListChanged(_ notif: Notification) {
        tableView.reloadData()
    }
    
    func setupUserInfo() {
        if AuthService.instance.isLoggedIN {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            userImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("here dequeueReusableCellWithIdentifier")
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels_Swift4[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels_Swift4.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels_Swift4[indexPath.row]
        MessageService.instance.selectedChanel = channel
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        // hide table view with channels and slode to the left showinc chat view
        self.revealViewController().revealToggle(animated: true)
    }
}
