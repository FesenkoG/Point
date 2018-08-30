//
//  EditProfileViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var ageButtons: [RoundedButton]!
    @IBOutlet var genderButtons: [UIButton]!
    @IBOutlet var genderLabels: [UILabel]!
    @IBOutlet var genderOkImages: [UIImageView]!
    
    let helper = Utils()
    var userInfo = NewUserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    @IBAction func saveButtonWasTapped(_ sender: Any) {
        
    }
    
    @IBAction func genderMaleButtonWasTapped(_ sender: Any) {
        
    }
    
    @IBAction func genderFemaleButtonWasTapped(_ sender: Any) {
        
    }
    
    //Preferences
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
    }
    
    @IBAction func preferredGenderButtonTapped(_ sender: UIButton) {
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
    }
    
    @IBAction func chooseDateOfBirthWasTapped(_ sender: Any) {
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
