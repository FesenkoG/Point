//
//  SignUpThirdStepViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 27.07.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import PhoneNumberKit

class SignUpThirdStepViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //Constraints
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    //Outlets
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var privacyPolicyButton: UnderlinedButton!
    @IBOutlet weak var checkboxButton: RoundedButton!
    @IBOutlet weak var nextButton: RoundedButton!
    @IBOutlet weak var phoneCodeTextField: PhoneNumberTextField!
    @IBOutlet weak var errorLabel: UILabel!
    //Variables
    var newUser: NewUser!
    var state: ScreenState = .sendPhone {
        didSet {
            switch state {
            case .sendPhone:
                nextButton.isEnabled = true
                nextButton.backgroundColor = Colors.enabledButtonColor.color()
                privacyPolicyButton.isHidden = true
                privacyPolicyLabel.isHidden = true
                checkboxButton.isHidden = true
                nextButton.setTitle("Get a verification code", for: .normal)
                phoneCodeTextField.text = ""
                phoneCodeTextField.placeholder = "Phone number"
                phoneCodeTextField.isPartialFormatterEnabled = true
            case .sendSms:
                nextButton.setTitle("Go!", for: .normal)
                nextButton.isEnabled = false
                nextButton.backgroundColor = Colors.disabledButtonColor.color()
                checkboxButton.setImage(nil, for: .normal)
                checkboxButton.isHidden = false
                privacyPolicyLabel.isHidden = false
                privacyPolicyButton.isHidden = false
                phoneCodeTextField.text = ""
                phoneCodeTextField.isPartialFormatterEnabled = false
                phoneCodeTextField.placeholder = "Verification code"
                newUser.telephone = phoneNumber
            }
        }
    }
    var phoneNumber: String!
    
    //Utils
    let helper = Utils()
    let parser = PhoneNumberKit()
    
    //Services
    let requestSender: IRequestSender = RequestSender()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
       helper.setConstraints(left: leftConstraint, top: topConstraint, right: rightConstraint)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkboxButtonTapped(_ sender: RoundedButton) {
        //TODO: - set a proper image here
        nextButton.isEnabled = sender.image(for: .normal) == nil ? false : true
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        switch state {
        case .sendPhone:
            do {
                let number = try parser.parse(phoneCodeTextField.text!)
                phoneNumber = "+" + String(describing: number.countryCode) + number.adjustedNationalNumber()
                requestSender.send(config: RequestFactory.RegistrasionRequests.getSendPhoneConfig(phone: phoneNumber)) { (result) in
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
            guard let sms = phoneCodeTextField.text, !sms.isEmpty else { return }
            requestSender.send(config: RequestFactory.RegistrasionRequests.getSubmitSmsConfig(phone: phoneNumber, sms: sms)) { (result) in
                switch result {
                case .error(let error):
                    print(error)
                case .success(let res):
                    print(res)
                    if res {
                        self.requestSender.send(config: RequestFactory.RegistrasionRequests.getCreateAccountConfig(user: self.newUser)) { (result) in
                            switch result {
                            case .error(let error):
                                print(error)
                            case .success(let res):
                                UserDefaults.standard.set(res, forKey: "token")
                                //TODO: Perform segue to the main screen
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    @IBAction func tryAgainButtonTapped(_ sender: Any) {
        
    }
    
}

enum ScreenState {
    case sendPhone
    case sendSms
}
