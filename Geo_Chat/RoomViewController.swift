//
//  RoomViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 11.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {
    
    let room = ["ROMM 1", "ROOM 2", "ROOM 3"]
    let roomSend = ["numberOne", "numberTwo", "numberThree"]

    
    var nameUser = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        print(nameUser)
        // Do any additional setup after loading the view.
    }


}
extension RoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listRoomCell", for: indexPath) as! RoomTableViewCell
        cell.textLabel?.text = room[indexPath.row]
        
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendDataSegue" {
                let dvc =  segue.destination as! ChatViewController
                dvc.nameVC = roomSend[0]
            dvc.idUser = nameUser
                // Передача данных через сигвей
            }
        }
    
    
}
