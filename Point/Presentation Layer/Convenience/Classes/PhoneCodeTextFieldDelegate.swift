//
//  PhoneCodeTextFieldDelegate.swift
//  Point
//
//  Created by Георгий Фесенко on 26/01/2019.
//  Copyright © 2019 Георгий Фесенко. All rights reserved.
//

import UIKit


final class PhoneCodeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if newString.count < 6 {
            textField.text = newString
        }
        
        return false
    }
}
