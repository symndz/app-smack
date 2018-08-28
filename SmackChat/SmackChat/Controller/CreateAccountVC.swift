//
//  CreateAccountVC.swift
//  SmackChat
//
//  Created by training on 23.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    
    // Outlets
    
    @IBOutlet weak var spinnerR: UIActivityIndicatorView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var useremailTxt: UITextField!
    @IBOutlet weak var userpasswordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    // Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var avatarBgColor : UIColor? //OPTIONAL variable!!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            if avatarName.contains("light") && avatarBgColor == nil {
                userImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        spinnerR.isHidden = false
        spinnerR.startAnimating()
        
        guard let name = usernameTxt.text , usernameTxt.text != "" else { return }
        guard let email = useremailTxt.text , useremailTxt.text != "" else { return }
        guard let pass  = userpasswordTxt.text , userpasswordTxt.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: pass)
        { (success) in
            if success {
                print("user registered!")
                AuthService.instance.loginUser(email: email, password: pass, completion: {
                    ( success ) in
                    if success {
                        // print("logged in user! yeah!", AuthService.instance.authToken)
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                print(UserDataService.instance.name, UserDataService.instance.avatarName)
                                self.spinnerR.isHidden = true
                                self.spinnerR.stopAnimating()
                                
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                                
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        })
                    }
                    })
            }
        }
    }
    
    // Actions
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func pickBgColorPressed(_ sender: Any) {
        let r = CGFloat( arc4random_uniform(255)) / 255
        let g = CGFloat( arc4random_uniform(255)) / 255
        let b = CGFloat( arc4random_uniform(255)) / 255
        let alphabeta = CGFloat( 1 ) // not transparent at all
        avatarBgColor = UIColor(red: r, green: g, blue: b, alpha: alphabeta)
        avatarColor = "[\(r), \(b), \(g), 1]"
        
        // and then
        UIView.animate(withDuration: 0.25) {
            self.userImg.backgroundColor = self.avatarBgColor
        }
    }
    
    @IBAction func closeAccountBtnPressed(_ sender: Any) {
        // dismiss(animated: true, completion: nil)
        // or this
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    func setupView() {
        spinnerR.isHidden = true
        
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "#username", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        useremailTxt .attributedPlaceholder = NSAttributedString(string: "#email", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        userpasswordTxt.attributedPlaceholder = NSAttributedString(string: "#password", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTapOnScreen))
        view.addGestureRecognizer(tap)
    }

    @objc func handleTapOnScreen() {
        view.endEditing(true)
    }
}
