//
//  ReallyGoodTableViewController.swift
//  Training
//
//  Created by Yaroslav on 10.03.2018.
//  Copyright © 2018 Yaroslav. All rights reserved.
//

import UIKit
import Firebase
var nameUser = ""
var lastRoomMessageSend = [String]()
var lastRoomMessageEmail = [String]()
class ReallyGoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
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
    //
    // Имена комнат в базе ( временно )
    let roomSend = ["numberOne", "numberTwo", "numberThree", "numberFour", "numberFive"]
    
    // Имя пользователя под которым мы зашли
    
    var ref: DatabaseReference!
    var task: [Contact] = []
    
    //
    // Ярослав
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "Geo_chat").child("Users")
        
        tableView.separatorStyle = .none
        tableView.backgroundView?.backgroundColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 0.3 )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        // Считываем все содержимое по адресу ( смотреть fireBaseDataChat -> ref )
        
//        fireBaseDataChat2()
//        dowloadsListRoom()
//        observeMessageStruct()
    }

   
    func fireBaseDataChat3(text: String) {
      
        refMessagesCount = Database.database().reference(withPath: "Geo_chat").child("ROOM").child(text)
    }
    func fireBaseDataChat2() {
        
        refMessages = Database.database().reference(withPath: "Geo_chat").child("ROOM")
    }
    func dowloadsListRoom() {
        refMessages.observe(.value) { [weak self] (snapshot) in
            let index = Int(snapshot.childrenCount)
            print("index = \(index)")
            
            
            for int in 0..<5 {
            
        print("первый цикл - выполняется \(int + 1)ый раз")
            self?.fireBaseDataChat3(text: (self?.roomSend[int])!)
            self?.refMessagesCount.observe(.value, with: { (snapshot) in
                var _listMessages = Array<Messages>()
            
                for i in snapshot.children {
                    let task = Messages(snapshot: i as! DataSnapshot)
                    
                    _listMessages.append(task)
                }
                self?.messageCount = _listMessages
                
                if (self?.messageCount.count)! <= 0 {

                    self?.lastRoomMessage.append("no message")
                } else {
                    let deleteMessage = self?.messageCount.removeLast()
                    print(deleteMessage?.message)
                    self?.lastRoomMessage.append((deleteMessage?.message)!)
                }
                
                print(self?.lastRoomMessage.count)
                print(self?.lastRoomMessage)
            })
           // print("number element \(int)")
        }
            
           
        
        }
        
    
    
    observeMessageStruct()
    }
    
    func observeMessageStruct() {
        print("4")
        for i in 0..<messageCount.count {
            
            print(">>>>>message \(messageCount[i].message)")
        }
    }
    
    
    
    
    
    
    
    // MARK: - Table view data source
    
    //
    // Ярослав
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //
    // Ярослав
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room.count
    }
    
    //
    // Ярослав
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "W2Cell", for: indexPath) as! ChatRoomTableViewCell
        
        let bgColors = cell.mainViewBackgroundColors // блок кода, отвечающий за фон чата. IndexPath не выйдет за пределы массива с цветом
        cell.mainView.backgroundColor = { () -> UIColor in
            let cur = indexPath.row / bgColors.count
            return bgColors[indexPath.row - bgColors.count * cur]
        }()
        
      //  if lastRoomMessage.count == chatRoomName.count
        
        cell.chatRoomName.text = room[indexPath.row]
        cell.lastSender.text = "\(nameUser)"
        cell.lastText.text = lastRoomMessageSend[indexPath.row]
        cell.lastSender.text = lastRoomMessageEmail[indexPath.row]
        return cell
    }
    
    //
    // Ярослав
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    //
    // Ярослав
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //
    // Передача данных через сигвей
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         userIdNameJSQ = nameUser
        print("-roomVC ---\(userIdNameJSQ)")
        if segue.identifier == "sendDataSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc =  segue.destination as! ChatVCViewController
                dvc.nameVC = roomSend[indexPath.row]
                dvc.titleNameRoom = room[indexPath.row]
                
                dvc.contactName = task
            }
        }
    }
    
    func contact() {
        ref.observe(.value) { [weak self] (snapshot) in
            var _list = Array<Contact>()
            // создаем массив - который имеет туже стректуру что и messageTest
            //
            //
            // Цикл считываем все из snapshot ( снимок ) и помещаем в item
            for item in snapshot.children {
                //print(item)
                let task = Contact(snapshot: item as! DataSnapshot)
                // Создаем стректуру - которая будет иметь все ключи из snapshot
                //
                //
                // Добавляем все содержимое в массив ( смотреть строку 104 )
                _list.append(task)
            }
            
            // Переносим вне цикла все содержимое из _list в массив сообщений
            self?.task = _list
            
        }
    }
    
    //
    // Выход из учетной записи
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






