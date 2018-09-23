//
//  Colors.swift
//  Point
//
//  Created by Георгий Фесенко on 25.07.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

enum Colors {
    case disabledButtonColor
    case checkedTextColor
    case uncheckedTextColor
    case enabledButtonColor
    case male
    case female
    
    func color() -> UIColor {
        switch self {
        case .disabledButtonColor:
            return #colorLiteral(red: 0.7843137255, green: 0.768627451, blue: 0.8078431373, alpha: 1)
        case .checkedTextColor:
            return #colorLiteral(red: 0.2549019608, green: 0.2352941176, blue: 0.3450980392, alpha: 1)
        case .uncheckedTextColor:
            return #colorLiteral(red: 0.6980392157, green: 0.6901960784, blue: 0.7411764706, alpha: 1)
        case .enabledButtonColor:
            return #colorLiteral(red: 0.5294117647, green: 0.2784313725, blue: 0.9058823529, alpha: 1)
        case .male:
            return #colorLiteral(red: 0.5764705882, green: 0.568627451, blue: 0.9725490196, alpha: 1)
        case .female:
            return #colorLiteral(red: 0.9882352941, green: 0.5607843137, blue: 0.6666666667, alpha: 1)
        }
    }
}

