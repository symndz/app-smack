//
//  LoginVCViewController.swift
//  SmackChat
//
//  Created by training on 23.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //Outlets
    
    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var userpasswordTxt: UITextField!
    
    @IBOutlet weak var spinnerL: UIActivityIndicatorView!
    
    //Actions
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        spinnerL.isHidden = false
        spinnerL.startAnimating()
        
        guard let email = usernameTxt.text , usernameTxt.text != "" else { return }
        guard let pass = userpasswordTxt.text , userpasswordTxt.text != "" else { return }
        
        AuthService.instance.loginUser(email: email, password: pass) { (success) in
            AuthService.instance.findUserByEmail(completion: { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                    self.spinnerL.isHidden = true
                    self.spinnerL.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        spinnerL.isHidden = true
        
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "#username", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        userpasswordTxt.attributedPlaceholder = NSAttributedString(string: "#password", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])

        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTapOnScreen))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTapOnScreen() {
        view.endEditing(true)
    }

}
