//
//  OutgoingCell.swift
//  Point
//
//  Created by Георгий Фесенко on 28/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class OutgoingCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageView: MessageView!
    @IBOutlet weak var personImageView: CircleImage!
    
    func configure(_ model: Message) {
        messageLabel.text = model.text
        timeLabel.text = model.date
    }
    
}
