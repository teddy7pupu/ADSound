//
//  LoginViewController.swift
//  ADSound
//
//  Created by msp310 on 2018/3/22.
//  Copyright © 2018年 msp310. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController,
    GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var passwdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
    //MARK: Layout & Animation
    func setupLayout() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.keyboardDismiss(gesture:)))
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
        
        accountField.text = "admin@teddy.com"
        passwdField.text = "111111"
    }
    
    @IBAction func onGoogleLogin(_ sender: Any) {
        let signIn = GIDSignIn.sharedInstance()
        signIn?.clientID = FirebaseApp.app()?.options.clientID
        signIn?.delegate = self
        signIn?.uiDelegate = self
        tbHUD.show()
        signIn?.signIn()
    }
    
    @IBAction func onLogin(_ sender: Any) {
        guard let email = accountField.text, let pwd = passwdField.text else {
            self.showAlert(message: "請輸入正確登入資訊")
            return
        }
        tbHUD.show()
        UserManager.sharedInstance().signIn(email: email, password: pwd) { (user, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            tbHUD.dismiss()
            self.performSegue(withIdentifier: adDefines.kSegueAdmin, sender: nil)
        }
    }
    
    //MARK: GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            NSLog("%@", error.localizedDescription)
            self.showAlert(message: "登入失敗")
            return
        }
        
        let email = user.profile.email
        print(email as Any)
        
        UserManager.sharedInstance().signIn(user: user) { (user: User!, error: Error!) in
            tbHUD.dismiss()
            self.performSegue(withIdentifier: adDefines.kSegueGoogle, sender: nil)
        }
    }
    
    override func keyboardDismiss(gesture: UITapGestureRecognizer?) {
        self.view.endEditing(true)
    }
}
