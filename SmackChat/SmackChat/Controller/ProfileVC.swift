//
//  ProfileVC.swift
//  SmackChat
//
//  Created by training on 28.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    
    // Outlets
    @IBOutlet weak var closeModalBtn: UIButton!
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    // Actions
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        // and post notifications also
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func handleTapOnScreen(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        if UserDataService.instance.name != "" {
            userName.text = UserDataService.instance.name
        }
        if UserDataService.instance.email != "" {
            userEmail.text = UserDataService.instance.email
        }
        if UserDataService.instance.avatarName != "" {
            profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        }
        if UserDataService.instance.avatarColor != "" {
            profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.handleTapOnScreen(_ :)))
        bgView.addGestureRecognizer(tap)
    }

}
