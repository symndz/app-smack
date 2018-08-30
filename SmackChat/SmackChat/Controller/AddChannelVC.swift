//
//  AddChannelVC.swift
//  SmackChat
//
//  Created by training on 29.08.2018.
//  Copyright © 2018 Developers. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    
    // Outlets
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var channelDescTxt: UITextField!
    
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Actions
    @IBAction func closeModalPressed(_ sender: Any) {
        print("dismiss button")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let channelName = nameTxt.text , nameTxt.text != "" else { return }
        guard let channelDesc = channelDescTxt.text , channelDescTxt.text != "" else { return }
        
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDesc) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("DBG adding new channel from button done")
            } else {
                print("DBG adding failed new channel from button done")
            }
        }
    }
    
    
    // other
    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.handleTapOnScreen(_:)))
        bgView.addGestureRecognizer(tap)
        
        nameTxt.attributedPlaceholder = NSAttributedString(string: "#name", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        channelDescTxt.attributedPlaceholder = NSAttributedString(string: "#description", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        print("setupView")
    }
    
    // other
    @objc func handleTapOnScreen(_ recognizer: UITapGestureRecognizer) {
        print("handleTapOnScreen")
        dismiss(animated: true, completion: nil)
    }
}
