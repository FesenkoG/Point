//
//  CircleView.swift
//  Point
//
//  Created by Георгий Фесенко on 25.07.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {
    
    
    @IBInspectable var filled: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var strokeWidth: CGFloat = 1.5
    @IBInspectable var strokeColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    @IBInspectable var fillColor: UIColor = UIColor.black
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(circleIn: rect)
        bezierPath.lineWidth = strokeWidth
        if filled {
            self.fillColor.setStroke()
            self.fillColor.setFill()
            bezierPath.stroke()
            bezierPath.fill()
        } else {
            self.strokeColor.setStroke()
            bezierPath.stroke()
        }
        
    }
    
}

extension UIBezierPath {
    convenience init(circleIn rect: CGRect) {
        self.init()
        
        
        let radius = rect.size.width/2 - 2
        let center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        
        self.addArc(withCenter: center, radius: radius, startAngle: CGFloat(0.0.degreesToRadians), endAngle: CGFloat(360.0.degreesToRadians), clockwise: true)
        
        self.close()
    }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
