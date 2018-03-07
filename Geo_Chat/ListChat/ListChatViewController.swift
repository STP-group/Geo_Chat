//
//  ListChatTableViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 06.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import Firebase

class ListChatViewController: UIViewController {

    var login: String?
    
    
    var user: UserInfo!
    var ref: DatabaseReference!
    var listUsers = Array<Contacts>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserInfo(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("listUsers")
        let list = Contacts(name: login!, userId: user.uid)
        let listRef = self.ref.child(list.name.lowercased())
        listRef.setValue(["title": list.name])
    }
    
    @IBAction func exitPersonal(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: false, completion: nil
        )
    }

    
    
}



extension ListChatViewController: UITabBarDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listChatCell", for: indexPath) as! ListChatTableViewCell
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        
        return cell
    }
}
