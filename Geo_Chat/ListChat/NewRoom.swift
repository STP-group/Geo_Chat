//
//  NewRoom.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 29.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import Foundation
import Firebase

struct CreateRoomCell {
    let name: String
    let locationX: Double
    let locationY: Double
    let ref: DatabaseReference?
    
    init(name: String, locationX: Double, locationY: Double) {
        self.name = name
        self.locationX = locationX
        self.locationY = locationY
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        locationX = snapshotValue["locationX"] as! Double
        locationY = snapshotValue["locationY"] as! Double
        ref = snapshot.ref
    }
}
