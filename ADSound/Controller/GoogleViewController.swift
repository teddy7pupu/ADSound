//
//  GoogleViewController.swift
//  ADSound
//
//  Created by msp310 on 2018/3/22.
//  Copyright © 2018年 msp310. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleViewController: UITableViewController {
    
    var member: Member?
    @IBOutlet weak var sidField: UITextField!
    @IBOutlet weak var onlineSwitch: UISwitch!
    @IBOutlet weak var acrIdField: UITextField!
    @IBOutlet weak var domainField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sidField.text = member?.number
        onlineSwitch.isOn = (member?.online)!
        acrIdField.text = member?.acrId
        domainField.text = member?.adDomain
        mailField.text = member?.mail
        nameField.text = member?.name        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSignout(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        UserManager.sharedInstance().signOut()
        self.navigationController?.popViewController(animated: true)
    }
}
