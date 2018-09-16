//
//  RoundedImage.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = bounds.height / 2
    }
    
    
}

class CircleAroundImage: UIView {
    @IBInspectable var strokeWidth: CGFloat = 1.0
    @IBInspectable var strokeColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(circleIn: rect)
        bezierPath.lineWidth = strokeWidth
        self.strokeColor.setStroke()
        bezierPath.stroke()
    }
    
}
