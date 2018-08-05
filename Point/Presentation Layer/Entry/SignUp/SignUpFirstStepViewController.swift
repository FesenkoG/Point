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
    @IBOutlet weak var dateOfBirthButton: UIButton!
    //Utils
    let helper = Utils()
    
    //Services
    
    //Variables
    var userInfo: NewUser = NewUser()
    var datePicker : UIDatePicker = UIDatePicker()
    var datePickerContainer = UIView()
    var dateOfBirth: Date!
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        dateOfBirth = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        userInfo.myAge = String(describing: dateOfBirth.timeIntervalSince1970)
        dateOfBirthButton.setTitle(dateFormatter.string(from: dateOfBirth), for: .normal)
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
    @IBAction func chooseDateOfBirthButtonTapped(_ sender: UIButton) {
        
        datePickerContainer.frame = CGRect(x: 0.0, y: self.view.frame.height - 200, width: UIScreen.main.bounds.width, height: 200)
        datePicker.frame = CGRect(x: 0.0, y: 0, width: UIScreen.main.bounds.width, height: 200)
        guard let date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) else { return }
        datePicker.setDate(date, animated: true)
        datePicker.maximumDate = date
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(dateChangedInDate), for: UIControlEvents.valueChanged)
        datePickerContainer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        datePickerContainer.addSubview(datePicker)
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(#colorLiteral(red: 0.5803921569, green: 0.5725490196, blue: 0.9490196078, alpha: 1), for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        doneButton.addTarget(self, action: #selector(dismissPicker), for: .touchUpInside)
        doneButton.frame = CGRect(x: UIScreen.main.bounds.width - 70, y: 5.0, width: 70.0, height: 37.0)
        
        datePickerContainer.addSubview(doneButton)
        
        self.view.addSubview(datePickerContainer)
    }
    
    /**
     * MARK - observer to get the change in date
     */
    
    @objc func dateChangedInDate(sender:UIDatePicker){
        dateOfBirth = sender.date
        dateOfBirthButton.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    }// end dateChangedInDate
    
    /*
     * MARK - dismiss the date picker value
     */
    @objc func dismissPicker(sender: UIButton) {
        datePickerContainer.removeFromSuperview()
    }// end dismissPicker
    
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
            let finalDate = String(describing: dateOfBirth.timeIntervalSince1970)
            return (name, finalDate)
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



