//
//  Other code.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 30.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import Foundation

//    func fireBaseDataChat3(text: String) {
//
//        refMessagesCount = Database.database().reference(withPath: "Geo_chat").child("ROOM").child(text)
//    }
//    func fireBaseDataChat2() {
//
//        refMessages = Database.database().reference(withPath: "Geo_chat").child("ROOM")
//    }
//    func dowloadsListRoom() {
//        refMessages.observe(.value) { [weak self] (snapshot) in
//            let index = Int(snapshot.childrenCount)
//            print("index = \(index)")
//
//
//            for int in 0..<5 {
//
//                print("первый цикл - выполняется \(int + 1)ый раз")
//                self?.fireBaseDataChat3(text: (self?.rooms[int])!)
//                self?.refMessagesCount.observe(.value, with: { (snapshot) in
//                    var _listMessages = Array<Messages>()
//
//                    for i in snapshot.children {
//                        let task = Messages(snapshot: i as! DataSnapshot)
//
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
//                        print((deleteMessage?.message)!)
//                        self?.lastRoomEmail.append((deleteMessage?.nameUser)!)
//                        self?.lastRoomMessage.append((deleteMessage?.message)!)
//                        self?.lastRoomMessageCount.append("\((self?.messageCount.count)! + 1)")
//                        self?.lastRoomDate.append((deleteMessage?.date)!)
//                        print((deleteMessage?.date)!)
//             }
//                    lastRoomMessageSend = (self?.lastRoomMessage)!
//                    lastRoomMessageEmail = (self?.lastRoomEmail)!
//                    messageCountCell = (self?.lastRoomMessageCount)!
//                    lastRoomMessageDate = (self?.lastRoomDate)!
//                })
//
//            }
//        }
//        observeMessageStruct()
//    }
//
//    func observeMessageStruct() {
//        print("4")
//        for i in 0..<messageCount.count {
//
//            print(">>>>>message \(messageCount[i].message)")
//        }
//    }
//
//    @objc func handleMyFunction() {
//        print("1 timer")
//        tableView.reloadData()
//        fireBaseDataChat2()
//        dowloadsListRoom()
//        observeMessageStruct()
//
//    }
