//
//  CreateAccountVC.swift
//  SmackChat
//
//  Created by training on 23.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closeAccountBtnPressed(_ sender: Any) {
        // dismiss(animated: true, completion: nil)
        // or this
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    

}
