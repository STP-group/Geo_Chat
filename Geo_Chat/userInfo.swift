//
//  userInfo.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 07.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import Foundation
import Firebase

struct UserInfo {
    //let uid: String
    let email: String
    //let cell
    
    init(user: User) {
       // self.uid = user.uid
        self.email = user.email!
        // Coments
    }
    
}


