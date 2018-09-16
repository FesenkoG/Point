//
//  IncomingCell.swift
//  Point
//
//  Created by Георгий Фесенко on 28/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class IncomingCell: UITableViewCell {
    
    @IBOutlet weak var personImageView: CircleImage!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    func configure(_ message: Message) {
        messageTextLabel.text = message.text
    }
}
