//
//  SignInViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 25.07.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import PhoneNumberKit

class LogInViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //Constraints
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    //Outlets
    @IBOutlet weak var phoneNumberCodeTextField: PhoneNumberTextField!
    @IBOutlet weak var nextButton: RoundedButton!
    
    //Utils
    let helper = Utils()
    let parser = PhoneNumberKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        helper.setConstraints(left: leftConstraint, top: topConstraint, right: nil)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @IBAction func nextButtonWasPressed(_ sender: Any) {
        do {
            let number = try parser.parse(phoneNumberCodeTextField.text!)
            print(number.adjustedNationalNumber())
        } catch {
            print(error)
        }
    }
    
    @IBAction func tryAgainButtonWasPressed(_ sender: Any) {
    }
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
