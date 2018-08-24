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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let email = useremailTxt.text , useremailTxt.text != "" else { return }
        guard let pass  = userpasswordTxt.text , userpasswordTxt.text != "" else { return }
        
        AuthService.instance.RegisterUser(email: email, password: pass)
        { (success) in
            if success {
                print("user registered!")
            }
        }
    }
    
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
