//
//  RegisterNewUsers.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 03.04.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import Foundation
import Firebase
import UIKit

public class RegisterFirebase {
    
   private var ref: DatabaseReference! {
        didSet {
            ref = Database.database().reference(withPath: "Geo_chat")
        }
    }
    
    
    func newContactList(name: String, email: String, ref: DatabaseReference) {
        let list = Contact(name: name, email: email)
        let listRef = (ref.child("Users").child(list.name))
        listRef.setValue(["name": list.name, "email": list.email])
    }
}
