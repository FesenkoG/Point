//
//  MessageView.swift
//  Point
//
//  Created by NewUser on 16/09/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
@IBDesignable
class MessageView: UIView {
    
    @IBInspectable var unread: Bool = false {
        didSet {
            backgroundColor = unread ? #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1) : UIColor.white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        layer.borderWidth = 1
    }
}
