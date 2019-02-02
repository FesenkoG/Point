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
    let localStorage: ILocalStorage = LocalStorage()
    private let phoneCodeTextFieldDelegate = PhoneCodeTextFieldDelegate()
    
    //Variables
    var state: ScreenState = .sendPhone {
        didSet {
            switch state {
            case .sendPhone:
                tryAgainButton.isHidden = true
                nextButton.setTitle("Get a verification code".localized, for: .normal)
                phoneNumberCodeTextField.text = "+7"
                phoneNumberCodeTextField.maxDigits = 10
                phoneNumberCodeTextField.placeholder = "Phone number".localized
                errorLabel.isHidden = true
            case .sendSms:
                nextButton.setTitle("Go!".localized, for: .normal)
                tryAgainButton.isHidden = false
                phoneNumberCodeTextField.delegate = phoneCodeTextFieldDelegate
                phoneNumberCodeTextField.text = ""
                phoneNumberCodeTextField.isPartialFormatterEnabled = false
                phoneNumberCodeTextField.placeholder = "Verification code".localized
                errorLabel.isHidden = true
            }
        }
    }
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .sendPhone
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
                        self.showAlert(message: error)
                    case .success(let res):
                        print(res)
                        if res { self.state = .sendSms }
                    }
                }
                
            } catch {
                showAlert(message: error.localizedDescription)
            }
            
        case .sendSms:
            guard let sms = phoneNumberCodeTextField.text, !sms.isEmpty else { return }
            requestSender.send(config: RequestFactory.AuthenticationRequest.getSubmitSmsConfig(phone: phoneNumber, sms: sms)) { (result) in
                switch result {
                case .error(let error):
                    self.showAlert(message: error)
                    self.errorLabel.isHidden = false
                case .success(let res):
                    self.localStorage.saveUser(user: res.0, completion: { (error) in
                        if let error = error {
                            print(error)
                        } else {
                            self.localStorage.saveUserToken(res.token)
                            guard let mainTab = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController else { return }
                            mainTab.selectedIndex = 1
                            self.helper.configureTabBar(mainTab)
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
