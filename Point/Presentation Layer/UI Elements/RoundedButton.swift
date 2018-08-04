//
//  RoundedButton.swift
//  Point
//
//  Created by Георгий Фесенко on 25.07.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    

    var isChecked: Bool = false
    
    @IBInspectable var borderWidth: CGFloat = 1.5 {
        didSet {
            layer.borderWidth = borderWidth
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var borderColor: UIColor = #colorLiteral(red: 0.5294117647, green: 0.2784313725, blue: 0.9058823529, alpha: 1) {
        didSet {
            layer.borderColor = borderColor.cgColor
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 8 {
        didSet {
            layer.cornerRadius = cornerRadius
            self.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func setSelected() {
        borderColor = Colors.checkedTextColor.color()
        setTitleColor(Colors.checkedTextColor.color(), for: .normal)
    }
    
    public func deselect() {
        borderColor = Colors.uncheckedTextColor.color()
        setTitleColor(Colors.uncheckedTextColor.color(), for: .normal)
    }
}

