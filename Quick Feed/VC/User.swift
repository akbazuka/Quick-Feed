//
//  User.swift
//  Quick Feed
//
//  Created by Zachary Kline on 4/17/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//


struct UserStruct: Codable {
    let lifestyleID : String
    enum CodingKeys: String, CodingKey {
        case lifestyleID = "lifestyleID"
    }
}

class User{
    var lifestyleID :String
    init(lifestyleID: String){
        self.lifestyleID = lifestyleID
    }
}

