//
//  UserManager.swift
//  teddybear
//
//  Created by JLee21 on 2018/1/5.
//  Copyright © 2018年 AppMaster Co.,Ltd. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class UserManager: NSObject {
    
    private static var mInstance: UserManager?
    
    override private init() {
        super.init()
        mAuth = Auth.auth()
    }
    private var mAuth: Auth?
    private var mUser: User? {
        get {
            return mAuth?.currentUser
        }
    }
    
    // MARK: Public method
    static func sharedInstance() -> UserManager {
        if mInstance == nil {
            mInstance = UserManager()
        }
        return mInstance!
    }
    
    static func currentUser() -> User? {
        return UserManager.sharedInstance().mUser
    }
    
    func signIn(user: GIDGoogleUser, completion:@escaping (User?, Error?) -> Void) {
        guard let authentication = user.authentication else {
            return
        }

        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        //Firebase Auth signIn with credential
        mAuth?.signIn(with: credential, completion: completion)
    }
    
    func signIn(email: String, password: String, completion:@escaping (User?, Error?) -> Void) {
        //Firebase Auth signIn with Email/Password
        mAuth?.signIn(withEmail: email, password: password, completion: completion)
    }
    
    func signInAnonymously( completion:@escaping (User?, Error?) -> Void) {
        mAuth?.signInAnonymously(completion: completion)
    }
    
    func signOut() {
        do {
            try mAuth?.signOut()
        } catch let signOutError as NSError {
            NSLog("[Auth] Error:%@", signOutError)
        }
        NSLog("[Auth] SignOut success")
    }
}
