//
//  ChatVCViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 16.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatVCViewController: JSQMessagesViewController {
    
    var userIdName = ""
    var nameVC = ""
    var user: UsersInfo!
    var ref: DatabaseReference!
    var messages = [JSQMessage]()
    var userId = Array<Contact>()
    var messageTest = Array<Messages>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        fireBaseDataChat()
        print(nameVC)
        print(userIdName)
        

        
        
       
        self.senderId = userIdName
        self.senderDisplayName = userIdName

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
    
    func fireBaseDataChat() {
        guard let currentUser = Auth.auth().currentUser else { return }
        // user
        user = UsersInfo(user: currentUser)
        // Адрес пути в Database
        ref = Database.database().reference(withPath: "Geo_chat").child("ROOM").child(nameVC)
    }
    
   
    
    func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.observe(.value) { [weak self] (snapshot) in
            var _list = Array<Messages>()
            for item in snapshot.children {
                print(item)
                let task = Messages(snapshot: item as! DataSnapshot)
                
                _list.append(task)
            }
            
            self?.messageTest = _list
            
            
            var _ListItem = Array<JSQMessage>()
            for i in 0..<Int(snapshot.childrenCount) {
                print(i)
                let task = self?.messageTest[i].email
                let taskMessage = self?.messageTest[i].message
                _ListItem.append(JSQMessage(senderId: task, displayName: task, text: taskMessage))
            }
            self?.messages = _ListItem
            
//            self?.messages.append(JSQMessage(senderId: self?.messageTest[i].email, displayName: self?.messageTest[i].email, text: self?.messageTest[i].message))
            self?.collectionView.reloadData()
            
        }
    }
    
    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
//
//        senderDisplayName = messages[indexPath.row].senderDisplayName
//
//        return NSAttributedString(string: "senderDisplayName")
//    }
    
    
    // Заголовок по середине экрана
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        switch message.senderId {
        case senderDisplayName:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
            
        }
    }
    // размер шрифта для топ лабел
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 13
    }

    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
//        return 13 //or what ever height you want to give
//    }

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        if messages[indexPath.row].senderId == userIdName {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
        } else {
        return bubbleFactory?.incomingMessagesBubbleImage(with: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
            
    }
    }
        
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "user"), diameter: 30)
    }
    
    

    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {

        
        
        
        return messages[indexPath.item]
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        

        
        //cell.cellBottomLabel.text = messages[indexPath.row].senderDisplayName
        
        return cell
    }
    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
//        let message = messages[indexPath.item]
//        switch message.senderId {
//        case senderId:
//            return nil
//        default:
//            guard let senderDisplayName = message.senderDisplayName else {
//                assertionFailure()
//                return nil
//            }
//            return NSAttributedString(string: senderDisplayName)
//        }
//    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
//
        let text = Messages(message: text, email: userIdName, date: dateMessage(), indexMessage: senderId)

        let refMessage = self.ref.child(String(messageTest.count))
        refMessage.setValue(["message": text.message, "email": userIdName, "date": userIdName, "indexMessage": userIdName])

        messages.append(JSQMessage(senderId: text.email, displayName: text.email, text: text.message))
        
        
        collectionView.reloadData()
        finishSendingMessage()
       
    }
   

}
