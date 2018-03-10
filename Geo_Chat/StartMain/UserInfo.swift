//
//  UserInfo.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 10.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import Foundation
import Firebase

struct UsersInfo {
    //let name: String
    let email: String
    let uid: String
//    let location: Double
    
    init(user: User) {
        //self.name = user.displayName
        self.email = user.email!
        self.uid = user.uid
        
    }
}
