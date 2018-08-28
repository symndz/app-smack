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
    
    
    
    //Actions
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // Do any additional setup after loading the view.
    }
    
    func setupView() {
//        username.attributedPlaceholder = NSAttributedString(string: "#username", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
//        userpasswordTxt.attributedPlaceholder = NSAttributedString(string: "#password", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
//
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTapOnScreen))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTapOnScreen() {
        view.endEditing(true)
    }

}
