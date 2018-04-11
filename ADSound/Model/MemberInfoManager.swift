//
//  MemberInfoManager.swift
//  ADSound
//
//  Created by msp310 on 2018/4/11.
//  Copyright © 2018年 msp310. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class MemberInfoManager: NSObject{
    
    private static var mInstance: MemberInfoManager?
    private var dbRef: DatabaseReference?
    
    override private init() {
        super.init()
        dbRef = Database.database().reference()
    }
    
    //MARK: Public method
    static func sharedInstance() -> MemberInfoManager {
        if mInstance == nil {
            mInstance = MemberInfoManager()
        }
        return mInstance!
    }
    
    func updateInfo(_ memberInfo: MemberInfo!,completion:@escaping (MemberInfo?, Error?) -> Void) {
        memberInfoRef()?.child(memberInfo.mail!).updateChildValues(memberInfo.dictionaryData(), withCompletionBlock: { (error, reference) in
            if let error = error {
                completion(nil, error)
                return
            }
            completion(memberInfo, nil)
        })
    }
    
    func getMemberInfo(mail: String, completion:@escaping (MemberInfo?, Error?) -> Void) {
        memberInfo(key: mail, completion: completion)
    }
    
    private func memberInfo(key: String!, completion:@escaping (MemberInfo?, Error?) -> Void) {
        memberInfoRef()?.queryOrdered(byChild: key).observeSingleEvent(of: .value, with: { SnapShot in
            let data = SnapShot
            guard let memberInfo = MemberInfo.get(data: data.value as? NSDictionary) else {
                let error = NSError(domain: adDefines.BUNDLEID, code: -1, userInfo: [NSLocalizedDescriptionKey: "資料錯誤"])
                completion(nil, error)
                return
            }
            completion(memberInfo, nil)
        })
    }
    
    //MARK: Private Getter
    func memberInfoRef () -> DatabaseReference? {
        return dbRef?.child(adDefines.kMemberInfo)
    }
}

