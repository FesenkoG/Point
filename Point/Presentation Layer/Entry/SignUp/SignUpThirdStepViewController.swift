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
    
    // MARK: - Constraints
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var privacyPolicyButton: UnderlinedButton!
    @IBOutlet weak var checkboxButton: RoundedButton!
    @IBOutlet weak var nextButton: RoundedButton!
    @IBOutlet weak var phoneCodeTextField: PhoneNumberTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    // MARK: - Variables
    
    var newUser: NewUserModel!
    var state: ScreenState = .sendPhone {
        didSet {
            switch state {
            case .sendPhone:
                nextButton.isEnabled = true
                tryAgainButton.isHidden = true
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
                tryAgainButton.isHidden = false
                nextButton.isEnabled = false
                nextButton.backgroundColor = Colors.disabledButtonColor.color()
                checkboxButton.setImage(nil, for: .normal)
                checkboxButton.isHidden = false
                privacyPolicyLabel.isHidden = false
                privacyPolicyButton.isHidden = false
                phoneCodeTextField.text = ""
                phoneCodeTextField.isPartialFormatterEnabled = false
                phoneCodeTextField.placeholder = "Verification code"
                newUser.phone = phoneNumber
            }
        }
    }
    var phoneNumber: String!
    
    
    // MARK: - Utils
    
    let helper = Utils()
    let parser = PhoneNumberKit()
    
    
    // MARK: - Services
    
    let requestSender: IRequestSender = RequestSender()
    let localStorage: ILocalStorage = LocalDataStorage()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .sendPhone
        self.hideKeyboardWhenTappedAround()
        helper.setConstraints(left: leftConstraint, top: topConstraint, right: rightConstraint)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    // MARK: - IBActions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkboxButtonTapped(_ sender: RoundedButton) {
        //TODO: - set a proper image here
        if checkboxButton.image(for: .normal) == nil {
            checkboxButton.setImage(UIImage(named: "CheckedCheckBox"), for: .normal)
        } else {
            checkboxButton.setImage(nil, for: .normal)
        }
        nextButton.isEnabled = checkboxButton.image(for: .normal) == nil ? false : true
        nextButton.backgroundColor = checkboxButton.image(for: .normal) == nil ? Colors.disabledButtonColor.color() : Colors.enabledButtonColor.color()
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
                        self.showErrorAlert(error)
                    case .success(let res):
                        print(res)
                        if res { self.state = .sendSms }
                    }
                }
                
            } catch {
                self.showErrorAlert(error.localizedDescription)
            }
            
        case .sendSms:
            guard let sms = phoneCodeTextField.text, !sms.isEmpty else { return }
            newUser.sms = sms
            
            self.requestSender.send(config: RequestFactory.RegistrasionRequests.getCreateAccountConfig(user: self.newUser)) { (result) in
                switch result {
                case .error(let error):
                    self.showErrorAlert(error)
                case .success(let res):
                    self.localStorage.saveUserToken(res)
                    self.requestSender.send(config: RequestFactory.AuthenticationRequest.getAuthByTokenConfig(token: res), completionHandler: { (result) in
                        switch result {
                        case .error(let error):
                            self.showErrorAlert(error)
                        case .success(let res):
                            self.localStorage.saveUser(user: res.0, completion: { (error) in
                                if let error = error {
                                    self.showErrorAlert(error.localizedDescription)
                                } else {
                                    guard let mainTab = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController else { return }
                                    mainTab.selectedIndex = 1
                                    self.configureTabBar(mainTab)
                                    UIApplication.shared.keyWindow?.rootViewController = mainTab
                                }
                            })
                            
                        }
                    })
                    
                }
            }
        }
    }
    
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        guard let loginController = helper.getLoginViewController() else { return }
        UIApplication.shared.keyWindow?.rootViewController = loginController
    }
    
    @IBAction func tryAgainButtonTapped(_ sender: Any) {
        state = .sendPhone
    }
    
    
    // MARK: - Private methods
    
    private func configureTabBar(_ tabBarController: UITabBarController) {
        let tabBar = tabBarController.tabBar
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBarController.viewControllers?.forEach({ (controller) in
            controller.tabBarItem.setImageInsets()
        })
    }
    
}

enum ScreenState {
    case sendPhone
    case sendSms
}
