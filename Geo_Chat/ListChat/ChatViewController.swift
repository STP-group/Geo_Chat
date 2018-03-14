//
//  ChatViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 11.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITextViewDelegate {
    
    struct Messages {
        let message: String
        let email: String
        let date: String
        let indexMessage: String
        let ref: DatabaseReference?
        
        
        init(message: String, email: String, date: String, indexMessage: String) {
            self.message = message
            self.email = email
            self.date = date
            self.indexMessage = indexMessage
            self.ref = nil
        }
        init(snapshot: DataSnapshot) {
            let snapshotValue = snapshot.value as! [String: AnyObject]
            email = snapshotValue["email"] as! String
            message = snapshotValue["message"] as! String
            indexMessage = snapshotValue["indexMessage"] as! String
            date = snapshotValue["date"] as! String
            ref = snapshot.ref
        }
    }
    
    
    var indexes = [String]()
    var isScrollChatNeeded = false
    var isScrollChatForced = false
    var idUser = ""
    var nameVC = ""
    var user: UsersInfo!
    var ref: DatabaseReference!
    var userId = Array<Contact>()
    var message = Array<Messages>()
    //var indexMessage = "0"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.scrollChatToLastRowIfNeeded()
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = .clear
        print(nameVC)
        print(idUser)
        
        guard let currentUser = Auth.auth().currentUser else { return }
        // user
        user = UsersInfo(user: currentUser)
        // Адрес пути в Database
        ref = Database.database().reference(withPath: "lisUsers").child("messages")
        
    }
    func date() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let miliSeconds = calendar.component(.nanosecond, from: date)
        let time = "\(hour):\(minutes):\(seconds):\(miliSeconds)"
        return time
    }
    
    func dateMessage() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
         let miliSeconds = calendar.component(.nanosecond, from: date)
        let timeMessages = "\(hour):\(minutes):\(seconds):\(miliSeconds)"
        return timeMessages
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        guard messageTextField.text != "" else { return }
        let text = Messages(message: messageTextField.text!, email: idUser, date: dateMessage(), indexMessage: String(message.count))
        print(date())
        let refMessage = self.ref.child(String(message.count))
        refMessage.setValue(["message": text.message, "email": idUser, "date": text.date, "indexMessage": String(message.count)])
        //refMessage.setValue(["message": text.message, "email": idUser, "date": text.date, "indexMessage": message.count])
        messageTextField.text = ""
        
        
    }
    
    
    
    
    
}
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.observe(.value) { [weak self] (snapshot) in
            var _list = Array<Messages>()
            for item in snapshot.children {
                let task = Messages(snapshot: item as! DataSnapshot)
                _list.append(task)
            }
            
            self?.message = _list
            
            self?.tableView.reloadData()

            self?.scrollChatToLastRowIfNeeded()
            

        }
    }
    
    func scrollChatToLastRowIfNeeded() {
        if message.count <= 0  {
            return
        } else {
            let indexPath = IndexPath(row: message.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            
            self.message.sort {$0.self.indexMessage < $1.self.indexMessage }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return message.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //scrollChatToLastRowIfNeeded()
        if message[indexPath.row].email == idUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inCell", for: indexPath) as! FrendsMessageCell
            
            cell.messageText.text = message[indexPath.row].message
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "outCell", for: indexPath) as! ChatTestInTableViewCell
            
            cell.messageNyText.text = message[indexPath.row].message
            
            return cell
        }
    }
    
}
