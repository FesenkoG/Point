//
//  UnderlinedButton.swift
//  Point
//
//  Created by Георгий Фесенко on 25.07.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

@IBDesignable
class UnderlinedButton: UIButton {
    @IBInspectable var isUnderlined: Bool = false {
        didSet {
            guard let title = self.titleLabel?.text else { return }
            let textRange = NSMakeRange(0, title.count)
            let attributedText = NSMutableAttributedString(string: title)
            attributedText.addAttributes([NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue], range: textRange)
            setAttributedTitle(attributedText, for: .normal)
        }
    }
}

class UnderlinedLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttributes([NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue], range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}
