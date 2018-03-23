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
    var currerUser: String?
    
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
    
    @IBAction func onLogin(_ sender: Any) {
        guard let email = accountField.text, let pwd = passwdField.text else {
            self.showAlert(message: "請輸入正確登入資訊")
            return
        }
        tbHUD.show()
        UserManager.sharedInstance().signIn(email: email, password: pwd) { (user, error) in
            tbHUD.dismiss()
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            self.performSegue(withIdentifier: adDefines.kSegueAdmin, sender: nil)
        }
    }
    
    @IBAction func onGoogleLogin(_ sender: Any) {
        let signIn = GIDSignIn.sharedInstance()
        signIn?.clientID = FirebaseApp.app()?.options.clientID
        signIn?.delegate = self
        signIn?.uiDelegate = self
        tbHUD.show()
        signIn?.signIn()
    }
    
    func getMemberList(){
        MemberManager.sharedInstance().getMemberList(completion: { (member, error) in
            if let member = member { 
                if self.checkMember(member.mail) {
                    self.performSegue(withIdentifier: adDefines.kSegueGoogle, sender: nil)
                }
            }
            tbHUD.dismiss()
        })
    }
    
    func checkMember(_ mail: [String]?) -> Bool{
        if mail?.index(of: currerUser!) == nil{
            GIDSignIn.sharedInstance().signOut()
            UserManager.sharedInstance().signOut()
            self.showAlert(message: "查無廠商資訊")
            return false
        }
        return true
    }
    
    //MARK: GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            NSLog("%@", error.localizedDescription)
            self.showAlert(message: "登入失敗")
            tbHUD.dismiss()
            return
        }
        
        self.currerUser = user.profile.email
        
        UserManager.sharedInstance().signIn(user: user) { (user: User!, error: Error!) in
            self.getMemberList()
        }
    }
    
    override func keyboardDismiss(gesture: UITapGestureRecognizer?) {
        self.view.endEditing(true)
    }
}
