//
//  SignUpSecondStepViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 26.07.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class SignUpSecondStepViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //Constraints
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    //Outlets
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nextButton: RoundedButton!
    @IBOutlet var ageButtons: [RoundedButton]!
    @IBOutlet var genderLabels: [UILabel]!
    @IBOutlet var genderOkImages: [UIImageView]!
    @IBOutlet var genderButtons: [UIButton]!
    
    //Utils
    let helper = Utils()
    
    //Variables
    var userInfo: NewUserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       helper.setConstraints(left: leftConstraint, top: topConstraint, right: rightConstraint)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    @IBAction func ageButtonTapped(_ sender: RoundedButton) {
        helper.checkAgeButtons(sender: sender, otherButtons: ageButtons)
        switch sender {
        case ageButtons[0]:
            userInfo.yourAge = "18-22"
        case ageButtons[1]:
            userInfo.yourAge = "23-27"
        case ageButtons[2]:
            userInfo.yourAge = "28-35"
        case ageButtons[3]:
            userInfo.yourAge = "36-45"
        case ageButtons[4]:
            userInfo.yourAge = "46-99"
        case ageButtons[5]:
            userInfo.yourAge = "18-99"
        default:
            userInfo.yourAge = "18-99"
        }
        if helper.areAllFieldsOnSecondScreenFilled(age: ageButtons, gender: genderLabels) {
            configureNextButton(enabled: true)
        }
    }
    
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        guard let index = genderButtons.index(of: sender) else { return }
        helper.checkGenderButtons(index: index, images: genderOkImages, labels: genderLabels)
        switch Int(index) {
        case 0:
            userInfo.yourGender = "1"
        case 1:
            userInfo.yourGender = "0"
        default:
            userInfo.yourGender = "-1"
        }
        if helper.areAllFieldsOnSecondScreenFilled(age: ageButtons, gender: genderLabels) {
            configureNextButton(enabled: true)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if helper.areAllFieldsOnSecondScreenFilled(age: ageButtons, gender: genderLabels) {
            performSegue(withIdentifier: "showSignUpThirdStep", sender: nil)
        } else {
            configureNextButton(enabled: false)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func skipButtonTappeda(_ sender: Any) {
        userInfo.yourAge = "18-99"
        userInfo.yourGender = "-1"
        performSegue(withIdentifier: "showSignUpThirdStep", sender: nil)
    }
    
    private func configureNextButton(enabled: Bool) {
        nextButton.isEnabled = enabled
        errorLabel.isHidden = enabled
        nextButton.backgroundColor = enabled ? Colors.enabledButtonColor.color() : Colors.disabledButtonColor.color()
    }
    
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        guard let loginController = helper.getLoginViewController() else { return }
        UIApplication.shared.keyWindow?.rootViewController = loginController
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SignUpThirdStepViewController {
            vc.newUser = userInfo
        }
    }
    
    
}
