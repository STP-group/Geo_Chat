//
//  ListChatTableViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 06.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import Firebase
//import CoreData

class ListChatViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {

    // Передать инфо о комнате
    // Фильтр для учасников комнаты
    
    var list = ["комната №1", "комната №2", "комната №3"]
    var user: UsersInfo!
    var ref: DatabaseReference!
    var userId = Array<Contact>()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentUser = Auth.auth().currentUser else { return }
        // user
        user = UsersInfo(user: currentUser)
        // Адрес пути в Database
        ref = Database.database().reference(withPath: "lisUsers").child("1")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.observe(.value) { [weak self] (snapshot) in
            var _list = Array<Contact>()
            for item in snapshot.children {
                let list = Contact(snapshot: item as! DataSnapshot)
                _list.append(list)
            }
            self?.userId = _list
            self?.tableView.reloadData()
        }
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

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listChatCell", for: indexPath) as! ListChatTableViewCell
        
        
        cell.textLabel?.text = list[indexPath.row]
        
        
        
        return cell
    }
    
}



