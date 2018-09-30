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
    let localStorage: ILocalStorage = LocalDataStorage()
    
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
                nextButton.setTitle("Go!", for: .normal)
                tryAgainButton.isHidden = false
                phoneNumberCodeTextField.text = ""
                phoneNumberCodeTextField.isPartialFormatterEnabled = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
                    self.localStorage.saveUser(user: res.0, completion: { (error) in
                        if let error = error {
                            print(error)
                        } else {
                            UserDefaults.standard.set(res.token, forKey: "token")
                            guard let mainTab = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController else { return }
                            mainTab.selectedIndex = 1
                            UIApplication.shared.keyWindow?.rootViewController = mainTab
                        }
                    })
                }
            }
        }
    }
    @IBAction func signUpButtonWasPressed(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController = helper.getSignUpViewController()
    }
    
    @IBAction func tryAgainButtonWasPressed(_ sender: Any) {
        state = .sendPhone
    }
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
