//
//  Member.swift
//  ADSound
//
//  Created by msp310 on 2018/3/23.
//  Copyright © 2018年 msp310. All rights reserved.
//

import Foundation

struct Member: Codable {
    var name: String?     //廣套名稱
    var mail: String?     //mail名稱
    var acrId: String?    //acrId
    var adDomain: String? //跳轉網址
    var online: Bool?
    var number: String?   // 廠商編號
    init() {
    }
    
    func dictionaryData() -> [String: Any] {
        let encoder: JSONEncoder = JSONEncoder()
        let encoded = try? encoder.encode(self)
        return try! JSONSerialization.jsonObject(with: encoded!, options: .allowFragments) as! [String : Any]
    }
    
    static func get(data: NSDictionary?) -> Member? {
        if data != nil {
            guard let json = try? JSONSerialization.data(withJSONObject: data!, options: .prettyPrinted) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode(Member.self, from: json)
        }
        return nil
    }
}
