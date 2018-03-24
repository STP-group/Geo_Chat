//
//  Messages.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 14.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import Foundation
import Firebase

struct Messages {
    let message: String
    let email: String
    let date: String
    let nameUser: String
    let ref: DatabaseReference?
    
    
    init(message: String, email: String, date: String, nameUser: String) {
        self.message = message
        self.email = email
        self.date = date
        self.nameUser = nameUser
        self.ref = nil
    }
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        email = snapshotValue["email"] as! String
        message = snapshotValue["message"] as! String
        nameUser = snapshotValue["nameUser"] as! String
        date = snapshotValue["date"] as! String
        ref = snapshot.ref
    }
}
