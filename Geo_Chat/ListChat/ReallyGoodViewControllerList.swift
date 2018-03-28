//
//  ReallyGoodViewControllerList.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 28.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import Firebase
var nameUser = ""
var lastRoomMessageSend = [String]()
var lastRoomMessageEmail = [String]()
var messageCountCell = [String]()
var lastRoomMessageDate = [String]()

class ReallyGoodViewControllerList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference!
    var task: [Contact] = []
    var refMessages: DatabaseReference!
    var messageToVC: [Messages] = []
    var arrayListRoom: [Messages] = []
    var refMessagesCount: DatabaseReference!
    var messageCount: [Messages] = []
    var lastRoomMessage = [String]()
    var lastRoomEmail = [String]()
    var lastRoomMessageCount = [String]()
    var lastRoomDate = [String]()
    let room = ["Курилка", "18+", "Все рядом", "no name", "desk"]
    let roomSend = ["numberOne", "numberTwo", "numberThree", "numberFour", "numberFive"]
    @IBOutlet weak var tableView: UITableView!
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    @IBAction func reload(_ sender: UIBarButtonItem) {
        start()
        print("reload")
    }
    public func reloadDataCell() {
        fireBaseDataChat2()
        dowloadsListRoom()
        observeMessageStruct()
       
    }
    
    var timer: Timer?
    
    func start() {
        print("start timer")
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleMyFunction), userInfo: nil, repeats: true)
    }
       // timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(handleMyFunction), userInfo: nil, repeats: true)
   // }
    
   public func stop() {
    print("stop timer")
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let message = lastRoomMessageSend.removeLast()
         ref = Database.database().reference(withPath: "Geo_chat").child("Users")
        start()
        tableView.separatorStyle = .none
        tableView.backgroundView?.backgroundColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 0.3 )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        // Считываем все содержимое по адресу ( смотреть fireBaseDataChat -> ref )
        ref.observe(.value) { [weak self] (snapshot) in
            var _list = Array<Contact>()
            // создаем массив - который имеет туже стректуру что и messageTest
            //
            //
            // Цикл считываем все из snapshot ( снимок ) и помещаем в item
            for item in snapshot.children {
                print(item)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "W2Cell", for: indexPath) as! ChatRoomTableViewCell
        
        let bgColors = cell.mainViewBackgroundColors // блок кода, отвечающий за фон чата. IndexPath не выйдет за пределы массива с цветом
        cell.mainView.backgroundColor = { () -> UIColor in
            let cur = indexPath.row / (bgColors.count)
            return bgColors[indexPath.row - bgColors.count * cur]
        }()
        
        cell.chatRoomName.text = room[indexPath.row]
        cell.lastSender.text = "\(nameUser)"
        cell.lastText.text = lastRoomMessageSend[indexPath.row]
        cell.lastSender.text = lastRoomMessageEmail[indexPath.row]
        cell.numberOfPeopleInRoom.text = messageCountCell[indexPath.row]
        cell.lastTime.text = DateAndTimes().getTextInMidLabel2(date: DateAndTimes().getDateFrom2(string: lastRoomMessageDate[indexPath.row]))
       // return cell
        
       // cell.chatRoomName.text = room[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // userIdNameJSQ = nameUser
        print("-roomVC ---\(userIdNameJSQ)")
        stop() 
        if let indexPath = tableView.indexPathForSelectedRow {
          //  let dvc =  segue.destination as! ChatVCViewController
            nameVC = roomSend[indexPath.row]
            titleNameRoom = room[indexPath.row]
            userDataContact = task
            
        }
    }
    
    //
    // Ярослав
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
                        self?.lastRoomEmail.append("no user")
                        self?.lastRoomMessage.append("no message")
                        self?.lastRoomMessageCount.append("0")
                        self?.lastRoomDate.append(":(")
                    } else {
                        let deleteMessage = self?.messageCount.removeLast()
                        print((deleteMessage?.message)!)
                        self?.lastRoomEmail.append((deleteMessage?.nameUser)!)
                        self?.lastRoomMessage.append((deleteMessage?.message)!)
                        self?.lastRoomMessageCount.append("\((self?.messageCount.count)! + 1)")
                        self?.lastRoomDate.append((deleteMessage?.date)!)
                        print((deleteMessage?.date)!)
                        
                        
                    }
                    
                    
                    lastRoomMessageSend = (self?.lastRoomMessage)!
                    lastRoomMessageEmail = (self?.lastRoomEmail)!
                    messageCountCell = (self?.lastRoomMessageCount)!
                    lastRoomMessageDate = (self?.lastRoomDate)!
                   
                    
                })
                
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

    @objc func handleMyFunction() {
        print("1 timer")
        tableView.reloadData()
        fireBaseDataChat2()
        dowloadsListRoom()
        observeMessageStruct()
        
    }
    
}

