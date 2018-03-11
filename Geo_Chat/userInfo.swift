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
    let email: String
    
    init(user: User) {
        self.email = user.email!
    }    
}


