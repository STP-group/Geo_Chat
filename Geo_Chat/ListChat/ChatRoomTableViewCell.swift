//
//  W2TableViewCell.swift
//  Training
//
//  Created by Yaroslav on 10.03.2018.
//  Copyright © 2018 Yaroslav. All rights reserved.
//

import UIKit
class ChatRoomTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageForChatRoom: UIImageView!
    @IBOutlet weak var chatRoomName: UILabel!
    @IBOutlet weak var numberOfPeopleInRoom: UILabel!
    @IBOutlet weak var lastSender: UILabel!
    @IBOutlet weak var lastText: UILabel!
    @IBOutlet weak var lastTime: UILabel!
    @IBOutlet weak var distanceToRoom: UILabel!
    
    
    
    let mainViewBackgroundColors: [UIColor] = [UIColor(red: 74.0/255.0, green: 134.0/255.0, blue: 232.0/255.0, alpha: 1.0 ),
                                              UIColor(red: 51.0/225.0, green: 149.0/255.0, blue: 149.0/255.0, alpha: 1.0 ),
                                              UIColor(red: 224.0/255.0, green: 102/255.0, blue: 102.0/255.0, alpha: 1.0 )]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.cornerRadius = 15.0
        mainView.clipsToBounds = true
        mainView.layer.shadowOffset = CGSize(width: 0.5, height: 5.0)
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.2
        mainView.layer.masksToBounds = false
        
        imageForChatRoom.layer.cornerRadius = 15.0
        imageForChatRoom.clipsToBounds = true
        self.selectionStyle = .none
        self.backgroundColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 0.1 )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
