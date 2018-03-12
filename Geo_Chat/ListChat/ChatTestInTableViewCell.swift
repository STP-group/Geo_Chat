//
//  ChatTestInTableViewCell.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 11.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit

class ChatTestInTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMessageOutCell: UIView!{
        didSet {
            viewMessageOutCell.layer.cornerRadius = 5
            viewMessageOutCell.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var messageNyText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
