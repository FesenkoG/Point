//
//  GradientView.swift
//  Point
//
//  Created by NewUser on 20/09/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startLocation: Double =   0.05 { didSet { updatePoints() }}
    @IBInspectable var endLocation: Double =   0.95 { didSet { updatePoints() }}
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 5, y: 5)
    }
//    func updateLocations() {
//        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
    }
}
