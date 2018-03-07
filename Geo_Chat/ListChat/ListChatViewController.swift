//
//  ListChatTableViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 06.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ListChatViewController: UIViewController, NSFetchedResultsControllerDelegate {

    var fetchResultsController = NSFetchedResultsController<UserData>()
    
    var userData: [UserData] = []
    
    var login = "hi"
    
    
    var user: UserInfo!
    var ref: DatabaseReference!
    var listUsers = Array<Contacts>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let fethRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        do {
            userData = (try context?.fetch(fethRequest))!

            
        } catch {
            print(error.localizedDescription)
        }
        
       // print(login!)
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserInfo(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("listUsers")
        let list = Contacts(name: login, userId: user.uid)
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
        
        return userData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listChatCell", for: indexPath) as! ListChatTableViewCell
        
        cell.textLabel?.text = userData[indexPath.row].email

        
        
        return cell
    }
}
