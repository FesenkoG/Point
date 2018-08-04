//
//  SignUpViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 25.07.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class SignUpFirstStepViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    //Constraints
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var betweenConstraint: NSLayoutConstraint!
    
    //Outlets
    @IBOutlet weak var nextButton: RoundedButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var genderButtons: [RoundedButton]!
    
    //Utils
    let helper = Utils()
    
    //Services
    
    //Variables
    var userInfo: NewUser = NewUser()
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        userInfo.myAge = "12456"
        nameTextField.delegate = self
        helper.setConstraints(left: leftConstraint, top: topConstraint, right: rightConstraint)
        helper.setBetweenConstraint(betweenConstraint)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    @IBAction func maleButtonTapped(_ sender: RoundedButton) {
        helper.checkAgeButtons(sender: sender, otherButtons: genderButtons)
        if !nextButton.isEnabled { _ = checkIfDataValidOrNot() }
        userInfo.myGender = "1"
    }
    @IBAction func femaleButtonTapped(_ sender: RoundedButton) {
        helper.checkAgeButtons(sender: sender, otherButtons: genderButtons)
        if !nextButton.isEnabled { _ = checkIfDataValidOrNot() }
        userInfo.myGender = "0"
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if let (name, date) = checkIfDataValidOrNot() {
            userInfo.myAge = date
            userInfo.nickname = name
            performSegue(withIdentifier: "showSignUpSecondStep", sender: nil)
        }
        
    }
    @IBAction func chooseDateOfBirthButtonTapped(_ sender: Any) {
        
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SignUpSecondStepViewController {
            vc.userInfo = userInfo
        }
    }
    
    func checkIfDataValidOrNot(_ futureString: String? = nil) -> (String, String)? {
        if let name = futureString == nil ? nameTextField.text : futureString, !name.isEmpty, genderButtons.contains(where: { (btn) -> Bool in
            return btn.isChecked
        }), !userInfo.myAge.isEmpty {
            errorLabel.isHidden = true
            nextButton.isEnabled = true
            nextButton.backgroundColor = Colors.enabledButtonColor.color()
            //TODO: - another date should be here
            return (name, "1234567")
        }
        errorLabel.isHidden = false
        nextButton.isEnabled = false
        nextButton.backgroundColor = Colors.disabledButtonColor.color()
        return nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "")  as NSString
        let futureString = currentText.replacingCharacters(in: range, with: string) as String
        if !futureString.isEmpty {
            _ = checkIfDataValidOrNot(futureString)
        }
        return true
    }
    
}



