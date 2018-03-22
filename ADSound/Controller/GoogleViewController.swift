//
//  GoogleViewController.swift
//  ADSound
//
//  Created by msp310 on 2018/3/22.
//  Copyright © 2018年 msp310. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
