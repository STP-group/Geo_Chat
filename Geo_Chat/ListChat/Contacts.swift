//
//  Contacts.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 10.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import Foundation
import Firebase

struct Contact {
    let name: String
    let email: String
    let ref: DatabaseReference?
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        email = snapshotValue["email"] as! String
        ref = snapshot.ref
    }
    
    
    
    
}
