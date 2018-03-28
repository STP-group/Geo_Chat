//
//  ReallyGoodTableViewController.swift
//  Training
//
//  Created by Yaroslav on 10.03.2018.
//  Copyright © 2018 Yaroslav. All rights reserved.
//

import UIKit
import Firebase
//var nameUser = ""
//var lastRoomMessageSend = [String]()
//var lastRoomMessageEmail = [String]()
//var messageCountCell = [String]()
//var lastRoomMessageDate = [String]()

class ReallyGoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
//    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
//
//    }


    // Название для комнат
    let room = ["Курилка", "18+", "Все рядом", "no name", "desk"]
    //
    // Имена комнат в базе ( временно )
    let roomSend = ["numberOne", "numberTwo", "numberThree", "numberFour", "numberFive"]
    
   
    // Ярослав
    override func viewDidLoad() {
        super.viewDidLoad()

       
       tableView.separatorStyle = .none
       tableView.backgroundView?.backgroundColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 0.3 )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
            let cur = indexPath.row / (bgColors.count)
            return bgColors[indexPath.row - bgColors.count * cur]
        }()
        
     
        cell.chatRoomName.text = room[indexPath.row]
        cell.lastSender.text = "\(nameUser)"
        cell.lastText.text = lastRoomMessageSend[indexPath.row]
        cell.lastSender.text = lastRoomMessageEmail[indexPath.row]
        cell.numberOfPeopleInRoom.text = messageCountCell[indexPath.row]
        cell.lastTime.text = DateAndTimes().getTextInMidLabel2(date: DateAndTimes().getDateFrom2(string: lastRoomMessageDate[indexPath.row]))
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
        // userIdNameJSQ = nameUser
        print("-roomVC ---\(userIdNameJSQ)")

            if let indexPath = tableView.indexPathForSelectedRow {
                //let dvc =  segue.destination as! ChatVCViewController
               nameVC = roomSend[indexPath.row]
               titleNameRoom = room[indexPath.row]

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
    @IBAction func reloadData(_ sender: UIBarButtonItem) {
       
        print("reload data")
        tableView.reloadData()
       
        
    }

}





