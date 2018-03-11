//
//  ChatViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 11.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    struct Messages {
        let message: String
        let email: String
        let ref: DatabaseReference?
        
        
        init(message: String, email: String) {
            self.message = message
            self.email = email
            self.ref = nil
        }
        init(snapshot: DataSnapshot) {
            let snapshotValue = snapshot.value as! [String: AnyObject]
            message = snapshotValue["message"] as! String
            email = snapshotValue["email"] as! String
            ref = snapshot.ref
        }
    }
    var userIdmessage = "test@me.ru"
    var idUser = ""
    var nameVC = ""
    var user: UsersInfo!
    var ref: DatabaseReference!
    var userId = Array<Contact>()
    var message = Array<Messages>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentUser = Auth.auth().currentUser else { return }
        // user
        user = UsersInfo(user: currentUser)
        // Адрес пути в Database
        ref = Database.database().reference(withPath: nameVC)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.observe(.value) { [weak self] (snapshot) in
            var _list = Array<Messages>()
            for item in snapshot.children {
                let list = Messages(snapshot: item as! DataSnapshot)
                _list.append(list)
            }
            self?.message = _list
           // self?.tableView.reloadData()
        }
    }
}
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if message[indexPath.row].email != userIdmessage {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatInCell", for: indexPath) as! ChatInTableViewCell
            
            cell.textLabel?.text = message[indexPath.row].message
 
            return cell
        } else {
            
          let cell = tableView.dequeueReusableCell(withIdentifier: "ChatOutCell", for: indexPath) as! ChatOutTableViewCell
            
            cell.textLabel?.text = message[indexPath.row].message
            
            return cell
    }
    }
    
}
