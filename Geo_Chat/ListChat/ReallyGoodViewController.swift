//
//  ReallyGoodTableViewController.swift
//  Training
//
//  Created by Yaroslav on 10.03.2018.
//  Copyright © 2018 Yaroslav. All rights reserved.
//

import UIKit
import Firebase

class ReallyGoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let room = ["Курилка", "18+", "Все рядом", "no name", "desk"]
    let roomSend = ["numberOne", "numberTwo", "numberThree", "numberFour", "numberFive"]
    
    
    var nameUser = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundView?.backgroundColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 0.3 )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

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
            let cur = indexPath.row / bgColors.count
            return bgColors[indexPath.row - bgColors.count * cur]
        }()
        
        cell.chatRoomName.text = room[indexPath.row]
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendDataSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc =  segue.destination as! ChatVCViewController
            dvc.nameVC = roomSend[indexPath.row]
                print(roomSend[indexPath.row])
            dvc.userIdName = nameUser
        }
            // Передача данных через сигвей
        }
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

}
