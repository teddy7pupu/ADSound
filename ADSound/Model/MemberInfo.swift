//
//  Info.swift
//  ADSound
//
//  Created by msp310 on 2018/4/11.
//  Copyright © 2018年 msp310. All rights reserved.
//

import Foundation

struct MemberInfo: Codable {
    var mail: String?   //mail名稱
    var name: String?   //廠商名稱
    var domain: String? //跳轉網址
    var acrId: String?  //acrId
    
    init() {
    }
    
    func dictionaryData() -> [String: Any] {
        let encoder: JSONEncoder = JSONEncoder()
        let encoded = try? encoder.encode(self)
        return try! JSONSerialization.jsonObject(with: encoded!, options: .allowFragments) as! [String : Any]
    }
    
    static func get(data: NSDictionary?) -> MemberInfo? {
        if data != nil {
            guard let json = try? JSONSerialization.data(withJSONObject: data!, options: .prettyPrinted) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode(MemberInfo.self, from: json)
        }
        return nil
    }
}
