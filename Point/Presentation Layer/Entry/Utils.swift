//
//  Utils.swift
//  Point
//
//  Created by Георгий Фесенко on 27.07.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class Utils {
    func setConstraints(left: NSLayoutConstraint, top: NSLayoutConstraint, right: NSLayoutConstraint?) {
        if UIScreen.main.bounds.width < 370 {
            left.constant = 20
            right?.constant = 30
            top.constant = 10
        }
    }
    
    func setBetweenConstraint(_ constraint: NSLayoutConstraint) {
        if UIScreen.main.bounds.width < 370 {
            constraint.constant = 40
        }
    }
    
    func checkAgeButtons(sender: RoundedButton, otherButtons: [RoundedButton]) {
        otherButtons.forEach { (btn) in
            btn.deselect()
            btn.isChecked = false
        }
        sender.isChecked ? sender.deselect() : sender.setSelected()
        sender.isChecked = !sender.isChecked
    }
    
    func checkGenderButtons(index: Int, images: [UIImageView], labels: [UILabel]) {
        _ = labels.map{ $0.textColor = Colors.uncheckedTextColor.color() }
        _ = images.map{ $0.image = UIImage(named: "uncheckedOk") }
        
        labels[index].textColor = Colors.checkedTextColor.color()
        images[index].image = UIImage(named: "checkedOk")
    }
    
    func areAllFieldsOnSecondScreenFilled(age: [RoundedButton], gender: [UILabel]) -> Bool {
        return age.contains(where: {$0.isChecked}) && gender.contains(where: {$0.textColor == Colors.checkedTextColor.color()})
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        swipe.direction = .down
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
