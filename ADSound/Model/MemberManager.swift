//
//  MemberManager.swift
//  ADSound
//
//  Created by msp310 on 2018/3/23.
//  Copyright © 2018年 msp310. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class MemberManager: NSObject{
    
    private static var mInstance: MemberManager?
    private var dbRef: DatabaseReference?
    
    override private init() {
        super.init()
        dbRef = Database.database().reference()
    }
    //MARK: Public method
    static func sharedInstance() -> MemberManager {
        if mInstance == nil {
            mInstance = MemberManager()
        }
        return mInstance!
    }
    
    func updateMember(_ member: Member!,completion:@escaping (Member?, Error?) -> Void) {
        memberRef()?.updateChildValues(member.dictionaryData(), withCompletionBlock: { (error, reference) in
            if let error = error {
                completion(nil, error)
                return
            }
            completion(member, nil)
        })
    }
    
    func getMemberList(completion:@escaping (Member?, Error?) -> Void) {
        memberList(key:"mail", completion: completion)
    }
    
    private func memberList(key: String!, completion:@escaping (Member?, Error?) -> Void) {
        memberRef()?.queryOrdered(byChild: key).observeSingleEvent(of: .value, with: { SnapShot in
            let data = SnapShot
            guard let member = Member.get(data: data.value as? NSDictionary) else {
                let error = NSError(domain: adDefines.BUNDLEID, code: -1, userInfo: [NSLocalizedDescriptionKey: "資料錯誤"])
                completion(nil, error)
                return
            }
            completion(member, nil)
        })
    }
    
    //MARK: Private Getter
    func memberRef () -> DatabaseReference? {
        return dbRef?.child(adDefines.kMember)
    }
}

