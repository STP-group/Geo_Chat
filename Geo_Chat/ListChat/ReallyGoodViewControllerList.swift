//
//  ReallyGoodViewControllerList.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 28.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation


// Global varibele
var nameUser = ""
var lastRoomMessageSend = [String]()
var lastRoomMessageEmail = [String]()
var messageCountCell = [String]()
var lastRoomMessageDate = [String]()
var userLocationLatitude = Double()
var userLocationLongitude = Double()

class ReallyGoodViewControllerList: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    // Артем
    //
    var refCreateRoom: DatabaseReference!
    var rooms: [CreateRoomCell] = []
    var timer: Timer?
    var refUserInfoDetail: DatabaseReference!
    var task: [Contact] = []
//    var refMessages: DatabaseReference!
//    var messageToVC: [Messages] = []
//    var arrayListRoom: [Messages] = []
//    var refMessagesCount: DatabaseReference!
//    var messageCount: [Messages] = []
//    var lastRoomMessage = [String]()
//    var lastRoomEmail = [String]()
//    var lastRoomMessageCount = [String]()
//    var lastRoomDate = [String]()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    }
    var distance = 500
    @IBAction func distanceSegment(_ sender: UISegmentedControl) {
    
        let caseDistance = sender.numberOfSegments
        print(sender.numberOfSegments)
        switch sender.selectedSegmentIndex {
        case 0:
            distance = 500
        case 1: distance = 1000
            case 2: distance = 5000
            case 3: distance = 25000
            case 4: distance = 10000000000
        default: break
            
        }
        tableView.reloadData()
    
    }
    
    // Артем
    //
    // Создание новой комнаты ( для создания нужно название комнаты, геоданные ( широта и долгота ))
    func newRoom(name: String, locationX: Double, locationY: Double) {
        // Присвоение
        let newDateRooms = CreateRoomCell(name: name, locationX: locationX, locationY: locationY)
        // Новая папка на серваке
        let listRooms = self.refCreateRoom.child(name)
        // помещаем данные в папку
        listRooms.setValue(["name": newDateRooms.name, "locationX": newDateRooms.locationX, "locationY": newDateRooms.locationY])
        
    }
    
    
    // Артем
    // в разработке
    func startTimer() {
        print("start timer")
        //        guard timer == nil else { return }
        //        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(handleMyFunction), userInfo: nil, repeats: true)
    }
    
    // Артем
    //
    public func stopTimer() {
        print("stop timer")
//        guard timer != nil else { return }
//        timer?.invalidate()
//        timer = nil
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Артем
        //
        // Адрес комнат на сервере
        refCreateRoom = Database.database().reference(withPath: "Geo_chat").child("ROOM")
        // Адрес списка людей на сервере
        refUserInfoDetail = Database.database().reference(withPath: "Geo_chat").child("Users")
       // startTimer()
        // Ярослав
        //
        // убераем разделитель между ячейками
        tableView.separatorStyle = .none
        // Цвет фона
        tableView.backgroundView?.backgroundColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 0.3 )
    }
    
    
    
    // Артем
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Считываем все комнаты с сервера
        refCreateRoom.observe(.value) { [weak self] (snapshot) in
            // создаем массив - который имеет туже стректуру что и CreateRoomCell
            var _list = Array<CreateRoomCell>()
            // Цикл считываем все из snapshot ( снимок ) и помещаем в item
            for item in snapshot.children {
                print(item)
                // Создаем стректуру - которая будет иметь все ключи из snapshot
                let task = CreateRoomCell(snapshot: item as! DataSnapshot)
                // Добавляем все содержимое в массив ( смотреть строку 104 )
                _list.append(task)
            }
            // Переносим вне цикла все содержимое из _list в массив сообщений
            self?.rooms = _list
            self?.tableView.reloadData()
        }
        // Считываем все содержимое по адресу ( смотреть fireBaseDataChat -> ref )
        refUserInfoDetail.observe(.value) { [weak self] (snapshot) in
            // создаем массив - который имеет туже стректуру что и messageTest
            var _list = Array<Contact>()
            //
            // Цикл считываем все из snapshot ( снимок ) и помещаем в item
            for item in snapshot.children {
                // Создаем стректуру - которая будет иметь все ключи из snapshot
                let task = Contact(snapshot: item as! DataSnapshot)
                //
                // Добавляем все содержимое в массив
                _list.append(task)
            }
            // Переносим вне цикла все содержимое из _list в массив сообщений
            self?.task = _list
        }
    }
    
    // Ярослав
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Ярослав
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    
    
    
    // Ярослав
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "W2Cell", for: indexPath) as! ChatRoomTableViewCell
        let cell2 = cell
        // блок кода, отвечающий за фон чата. IndexPath не выйдет за пределы массива с цветом
        colorCell(indexPath: indexPath, cell: cell2)
//        let bgColors = cell.mainViewBackgroundColors
//        cell.mainView.backgroundColor = { () -> UIColor in
//            let cur = indexPath.row / (bgColors.count)
//            return bgColors[indexPath.row - bgColors.count * cur]
//        }()
        
        // Присвоение кординат комнаты для расчета растояния
        let locationUser = CLLocation(latitude: userLocationLatitude, longitude: userLocationLongitude)
        
        // Присвоение кординат пользователя для расчета растояния
        let locationRoom = CLLocation(latitude: rooms[indexPath.row].locationX, longitude: rooms[indexPath.row].locationY)
        
        // Вычисляем расстояние между комнатой и пользователем
        let distanceInMeters = locationRoom.distance(from: locationUser)
        
        // переводим в целое число ( пример: из 513.212405045983 в 513 )
        let subTitleText = "\(distanceInMeters)".components(separatedBy: ".")
        
        if distanceInMeters >= Double(distance) {
            cell.isHidden = true
            print(distanceInMeters)
            print(distance)
        } else {
            cell.isHidden = false
        }
        
        cell.chatRoomName.text = rooms[indexPath.row].name
        cell.distanceToRoom.text = subTitleText[0]
        //
        //    Временно в разработке
        //
        //        cell.chatRoomName.text = room[indexPath.row]
        //        cell.lastSender.text = "\(nameUser)"
        //        cell.lastText.text = lastRoomMessageSend[indexPath.row]
        //        cell.lastSender.text = lastRoomMessageEmail[indexPath.row]
        //        cell.numberOfPeopleInRoom.text = messageCountCell[indexPath.row]
        //        cell.lastTime.text = DateAndTimes().getTextInMidLabel2(date: DateAndTimes().getDateFrom2(string: lastRoomMessageDate[indexPath.row]))
        //
        
        return cell
    }
    func colorCell(indexPath: IndexPath, cell: ChatRoomTableViewCell) {
        let bgColors = cell.mainViewBackgroundColors
        cell.mainView.backgroundColor = { () -> UIColor in
            let cur = indexPath.row / (bgColors.count)
            return bgColors[indexPath.row - bgColors.count * cur]
        }()
    }
    
    // Ярослав
    //
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    // Артем
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            //  let dvc =  segue.destination as! ChatVCViewController
            nameVC = rooms[indexPath.row].name
            titleNameRoom = rooms[indexPath.row].name
            userDataContact = task
        }
    }
    
    //
    // Ярослав
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // Артем
    // Временная кнопка добавления комнаты
    @IBAction func reload(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "Новая комната", message: nil, preferredStyle: .alert)
        alertVC.addTextField { (textField: UITextField!) in
            textField.placeholder = "имя комнаты"
        }
        let save = UIAlertAction(title: "save", style: .default) { (action) in
            let textFieldNameRoom = alertVC.textFields![0] as UITextField
            self.newRoom(name: textFieldNameRoom.text!, locationX: userLocationLatitude, locationY: userLocationLongitude)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertVC.addAction(save)
        alertVC.addAction(cancel)
        present(alertVC, animated: true, completion: nil)

    }
    
    @IBAction func exitPersonal(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: false, completion: nil)
    }
    
}
