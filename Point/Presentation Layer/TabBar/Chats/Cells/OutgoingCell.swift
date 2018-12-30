//
//  OutgoingCell.swift
//  Point
//
//  Created by Георгий Фесенко on 28/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import AlamofireImage
import SkeletonView

class OutgoingCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageView: MessageView!
    @IBOutlet weak var personImageView: CircleImage!
    
    
    func configure(_ model: Message, imageUrl: URL?) {
        messageLabel.text = model.text
        timeLabel.text = DateHelper.convertTimestampToHoursAndMinutes(model.date)
        
        guard let url = imageUrl else { return }
        personImageView.af_setImage(withURL: url)
    }
    
}
