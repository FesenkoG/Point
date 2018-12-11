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
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    func getLoginViewController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let startController = storyboard.instantiateViewController(withIdentifier: "startController") as? MainViewController else { return nil }
        guard let loginViewControlelr = storyboard.instantiateViewController(withIdentifier: "loginController") as? LogInViewController else { return nil }
        let navigationController = UINavigationController(rootViewController: startController)
        navigationController.viewControllers = [startController, loginViewControlelr]
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    func getSignUpViewController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let startController = storyboard.instantiateViewController(withIdentifier: "startController")
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "signupController")
        let navigationController = UINavigationController(rootViewController: startController)
        navigationController.viewControllers = [startController, signUpViewController]
        return navigationController
        
    }
    
    func configureTabBar(_ tabBarController: UITabBarController) {
        let tabBar = tabBarController.tabBar
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBarController.viewControllers?.forEach({ (controller) in
            controller.tabBarItem.setImageInsets()
        })
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
