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
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    //Utils
    let helper = Utils()
    let parser = PhoneNumberKit()
    
    //Services
    let requestSender: IRequestSender = RequestSender()
    
    //Variables
    var state: ScreenState = .sendPhone {
        didSet {
            switch state {
            case .sendPhone:
                tryAgainButton.isHidden = true
                nextButton.setTitle("Get a verification code", for: .normal)
                phoneNumberCodeTextField.text = ""
                phoneNumberCodeTextField.placeholder = "Phone number"
                errorLabel.isHidden = true
            case .sendSms:
                tryAgainButton.isHidden = false
                phoneNumberCodeTextField.text = ""
                phoneNumberCodeTextField.placeholder = "Verification code"
                errorLabel.isHidden = true
            }
        }
    }
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        helper.setConstraints(left: leftConstraint, top: topConstraint, right: nil)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @IBAction func nextButtonWasPressed(_ sender: Any) {
        switch state {
        case .sendPhone:
            do {
                let number = try parser.parse(phoneNumberCodeTextField.text!)
                phoneNumber = "+" + String(describing: number.countryCode) + number.adjustedNationalNumber()
                requestSender.send(config: RequestFactory.AuthenticationRequest.getSendPhoneConfig(phone: phoneNumber)) { (result) in
                    switch result {
                    case .error(let error):
                        print(error)
                    case .success(let res):
                        print(res)
                        if res { self.state = .sendSms }
                    }
                }
                
            } catch {
                print(error)
            }
            
        case .sendSms:
            guard let sms = phoneNumberCodeTextField.text, !sms.isEmpty else { return }
            requestSender.send(config: RequestFactory.AuthenticationRequest.getSubmitSmsConfig(phone: phoneNumber, sms: sms)) { (result) in
                switch result {
                case .error(let error):
                    print(error)
                    self.errorLabel.isHidden = false
                case .success(let res):
                    print(res.0)
                    UserDefaults.standard.set(res.token, forKey: "token")
                    
                    //TODO: - Perform segue to the next screen, save data somehow
                    
                }
            }
        }
    }
    
    @IBAction func tryAgainButtonWasPressed(_ sender: Any) {
    }
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
