//
//  ChatCell.swift
//  Point
//
//  Created by Георгий Фесенко on 28/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import AlamofireImage

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: CircleImage!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func configure(_ model: Chat, imageUrl: URL?) {
        nameLabel.text = model.chatmade.nick
        lastMessageLabel.text = model.messages.last?.text ?? "No messages yet."
        guard let dateString = model.messages.last?.date,
                let date = Int(dateString) else { return }
        timeLabel.text = DateHelper.convertTimestampToHoursAndMinutes(date)
        
        guard let url = imageUrl else { return }
        avatarImageView.af_setImage(withURL: url)

    }
}
