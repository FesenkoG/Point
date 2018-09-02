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
    @IBOutlet var myGenderButtons: [RoundedButton]!
    
    //MARK: Utils
    let helper = Utils()
    
    //MARK: - Services
    let requestSender: IRequestSender = RequestSender()
    let localStorage: ILocalStorage = LocalDataStorage()
    
    //MARK: - Varisbles
    var editedProfileModel: EditedProfileModel!
    var editedImageModel: EditedImageModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        initialRetrieving()
    }
    
    
    @IBAction func saveButtonWasTapped(_ sender: Any) {
        requestSender.send(config: RequestFactory.SettingsRequests.getEditProfileConfig(newProfile: editedProfileModel)) { (result) in
            switch result {
            case .error(let error):
                print(error)
            case .success(let result):
                if result {
                    self.requestSender.send(config: RequestFactory.SettingsRequests.getEditImageConfig(newImage: self.editedImageModel), completionHandler: { (result) in
                        switch result {
                        case .error(let error):
                            print(error)
                        case .success(let result):
                            if result {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    })
                }
            }
        }
    }
    
    //TODO: - Animation
    @IBAction func genderMaleButtonWasTapped(_ sender: RoundedButton) {
        helper.checkAgeButtons(sender: sender, otherButtons: myGenderButtons)
        //editedProfileModel.myGender = "1"
        
    }
    
    @IBAction func genderFemaleButtonWasTapped(_ sender: RoundedButton) {
        helper.checkAgeButtons(sender: sender, otherButtons: myGenderButtons)
        //editedProfileModel.myGender = "0"
    }
    
    //Preferences
    @IBAction func ageButtonTapped(_ sender: RoundedButton) {
        helper.checkAgeButtons(sender: sender, otherButtons: ageButtons)
        switch sender {
        case ageButtons[0]:
            editedProfileModel.yourAge = "18-22"
        case ageButtons[1]:
            editedProfileModel.yourAge = "23-27"
        case ageButtons[2]:
            editedProfileModel.yourAge = "28-35"
        case ageButtons[3]:
            editedProfileModel.yourAge = "36-45"
        case ageButtons[4]:
            editedProfileModel.yourAge = "46-99"
        case ageButtons[5]:
            editedProfileModel.yourAge = "18-99"
        default:
            editedProfileModel.yourAge = "18-99"
        }
    }
    
    @IBAction func preferredGenderButtonTapped(_ sender: UIButton) {
        guard let index = genderButtons.index(of: sender) else { return }
        helper.checkGenderButtons(index: index, images: genderOkImages, labels: genderLabels)
        switch Int(index) {
        case 0:
            editedProfileModel.yourGender = "1"
        case 1:
            editedProfileModel.yourGender = "0"
        default:
            editedProfileModel.yourGender = "-1"
        }
    }
    
    @IBAction func chooseDateOfBirthWasTapped(_ sender: Any) {
        editedProfileModel.myAge = ""
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper functions
    private func initialRetrieving() {
        guard let userInfo = self.localStorage.getUserInfo() else { return }
        editedProfileModel.myAge = userInfo.myAge
        editedProfileModel.myGender = userInfo.myGender
        editedProfileModel.nickname = userInfo.nickname
        editedProfileModel.telephone = userInfo.telephoneHash
        editedProfileModel.token = ""
        editedProfileModel.yourAge = userInfo.yourAge
        editedProfileModel.yourGender = userInfo.yourGender
        
        editedImageModel.image = userInfo.image
        editedImageModel.token = ""
    }
}
