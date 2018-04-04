//
//  FirebaseOther.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 04.04.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import Foundation
import Firebase


class FirebaseOtherData {

var refMessages: DatabaseReference!
var messageToVC: [Messages] = []
var arrayListRoom: [Messages] = []
var refMessagesCount: DatabaseReference!
var messageCount: [Messages] = []
// для Firebase
//
// Название для комнат
let room = ["Курилка", "18+", "Все рядом", "no name", "desk"]
var lastRoomMessage = [String]()
var lastRoomEmail = [String]()
var lastRoomMessageCount = [String]()
var lastRoomDate = [String]()
//
// Имена комнат в базе ( временно )
let roomSend = ["numberOne", "numberTwo", "numberThree", "numberFour", "numberFive"]

//
var task: [Contact] = []



//    func dowloadsListRoomPartThree(text: String) {
//        refMessagesCount = Database.database().reference(withPath: "Geo_chat").child("ROOM").child(text)
//    }
//    func dowloadsListRoomPartTwo() {
//        refMessages = Database.database().reference(withPath: "Geo_chat").child("ROOM")
//    }
//    func dowloadsListRoomPartOne() {
//        refMessages.observe(.value) { [weak self] (snapshot) in
//            for int in 0..<5 {
//                self?.dowloadsListRoomPartThree(text: (self?.roomSend[int])!)
//                self?.refMessagesCount.observe(.value, with: { (snapshot) in
//                    var _listMessages = Array<Messages>()
//
//                    for i in snapshot.children {
//                        let task = Messages(snapshot: i as! DataSnapshot)
//                        _listMessages.append(task)
//                    }
//                    self?.messageCount = _listMessages
//
//                    if (self?.messageCount.count)! <= 0 {
//                        self?.lastRoomEmail.append("no user")
//                        self?.lastRoomMessage.append("no message")
//                        self?.lastRoomMessageCount.append("0")
//                        self?.lastRoomDate.append(":(")
//                    } else {
//                        let deleteMessage = self?.messageCount.removeLast()
//                        self?.lastRoomEmail.append((deleteMessage?.nameUser)!)
//                        self?.lastRoomMessage.append((deleteMessage?.message)!)
//                        self?.lastRoomMessageCount.append("\((self?.messageCount.count)! + 1)")
//                        self?.lastRoomDate.append((deleteMessage?.date)!)
//
//                    }
//
//                    lastRoomMessageSend = (self?.lastRoomMessage)!
//                    lastRoomMessageEmail = (self?.lastRoomEmail)!
//                    messageCountCell = (self?.lastRoomMessageCount)!
//                    lastRoomMessageDate = (self?.lastRoomDate)!
//                })
//            }
//        }
//    }
}
