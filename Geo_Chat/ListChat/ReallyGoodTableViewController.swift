//
//  ReallyGoodTableViewController.swift
//  Training
//
//  Created by Yaroslav on 10.03.2018.
//  Copyright © 2018 Yaroslav. All rights reserved.
//

import UIKit

class ReallyGoodTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundView?.backgroundColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 0.3 )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "W2Cell", for: indexPath) as! ChatRoomTableViewCell
        let bgColors = cell.mainViewBackgroundColors
        cell.mainView.backgroundColor = { () -> UIColor in
            let cur = indexPath.row / bgColors.count
            return bgColors[indexPath.row - bgColors.count * cur]
        }()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
