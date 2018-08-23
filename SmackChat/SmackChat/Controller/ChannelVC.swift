//
//  ChannelVC.swift
//  SmackChat
//
//  Created by training on 22.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    
    // Outlets section
    
    @IBOutlet weak var loginBtn: UIButton!
    
    // Actions section
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.revealViewController().rearViewRevealWidth =
            self.view.frame.size.width - 60
    }

}
