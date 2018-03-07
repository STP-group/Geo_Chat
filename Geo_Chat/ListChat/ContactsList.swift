//
//  ContactsList.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 07.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import Foundation
import Firebase

struct Contacts {
    let name: String
    let userId: String
    let ref: DatabaseReference?
    
    init(name: String, userId: String) {
        self.name = name
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        userId = snapshotValue["userId"] as! String
        ref = snapshot.ref
    }

}
