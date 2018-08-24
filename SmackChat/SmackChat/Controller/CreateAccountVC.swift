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
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var useremailTxt: UITextField!
    @IBOutlet weak var userpasswordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    // Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
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
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            }
                        })
                    }
                    })
            }
        }
    }
    
    // Actions
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
    }
    
    @IBAction func pickBgColorPressed(_ sender: Any) {
    }
    
    @IBAction func closeAccountBtnPressed(_ sender: Any) {
        // dismiss(animated: true, completion: nil)
        // or this
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    

}
