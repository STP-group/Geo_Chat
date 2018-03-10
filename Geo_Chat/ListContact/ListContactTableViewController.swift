//
//  ListContactTableViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 10.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import Firebase

class ListContactTableViewController: UITableViewController {

    var user: UserInfo!
    var ref: DatabaseReference!
    var listContacts = Array<Contact>()
    
    @IBOutlet var showView: UIView!
    
    @IBOutlet weak var tableViewShowContact: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserInfo(user: currentUser)
        ref = Database.database().reference(withPath: "lisUsers")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] (snapshot) in
            var _list = Array<Contact>()
            for item in snapshot.children {
                let list = Contact(snapshot: item as! DataSnapshot)
                _list.append(list)
            }
            self?.listContacts = _list
            self?.tableView.reloadData()
        }
    }
    
    func animationIn() {
        self.view.addSubview(showView)
        showView.center = self.view.center
        showView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        showView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.showView.alpha = 1
            self.showView.transform = CGAffineTransform.identity
        }
    }
    
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listContacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listContactCell", for: indexPath) as! ListContactTableViewCell

        let name = listContacts[indexPath.row].name
        cell.textLabel?.text = name

        return cell
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func showListContact(_ sender: UIBarButtonItem) {

    }
    
    
    
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
    }
    
    

}










