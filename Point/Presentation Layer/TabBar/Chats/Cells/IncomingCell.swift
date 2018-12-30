//
//  IncomingCell.swift
//  Point
//
//  Created by Георгий Фесенко on 28/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import SkeletonView

class IncomingCell: UITableViewCell {
    
    @IBOutlet weak var personImageView: CircleImage!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageView: MessageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    func configure(_ message: Message, imageUrl: URL?) {
        messageTextLabel.text = message.text
        timeLabel.text = DateHelper.convertTimestampToHoursAndMinutes(message.date)
        
        guard let url = imageUrl else { return }
        personImageView.af_setImage(withURL: url)
    }
}
