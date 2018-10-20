//
//  EditProfileViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import AVFoundation

class EditProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var ageButtons: [RoundedButton]!
    @IBOutlet var genderButtons: [UIButton]!
    @IBOutlet var genderLabels: [UILabel]!
    @IBOutlet var genderOkImages: [UIImageView]!
    @IBOutlet var myGenderButtons: [RoundedButton]!
    @IBOutlet weak var dateOfBirthButton: UIButton!
    @IBOutlet weak var userImageView: CircleImage!
    //MARK: Utils
    let helper = Utils()
    
    //MARK: - Services
    let requestSender: IRequestSender = RequestSender()
    let localStorage: ILocalStorage = LocalDataStorage()
    
    //MARK: - Varisbles
    var editedProfileModel = EditedProfileModel()
    var editedImageModel = EditedImageModel()
    let datePickerContainer = UIView()
    let datePicker = UIDatePicker()
    var chooseImageAlert: UIAlertController!
    private lazy var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        editedProfileModel.token = token
        editedImageModel.token = token
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        initialRetrieving()
        setupGestureRecognizers()
    }
    
    
    @IBAction func saveButtonWasTapped(_ sender: Any) {
        requestSender.send(config: RequestFactory.SettingsRequests.getEditProfileConfig(newProfile: editedProfileModel)) { (result) in
            switch result {
            case .error(let error):
                self.showErrorAlert(error)
            case .success(let result):
                if result {
                    self.requestSender.send(config: RequestFactory.SettingsRequests.getEditImageConfig(newImage: self.editedImageModel), completionHandler: { (result) in
                        switch result {
                        case .error(let error):
                            self.showErrorAlert(error)
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
    @objc func didTapPhoto() {
        imagePicker.delegate = self
        chooseImageAlert = UIAlertController(title: "Выбрать фотографию", message: "Как бы вы хотели выбрать фотографию для своего профиля?", preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: "Взять из галереи", style: .default) { (buttonTapped) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        }
        
        let photoAction = UIAlertAction(title: "Сделать фото", style: .default) { (buttonTapped) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            DispatchQueue.main.async {
                if response {
                    self.chooseImageAlert.addAction(photoAction)
                }
                self.chooseImageAlert.addAction(galleryAction)
                self.present(self.chooseImageAlert, animated: true, completion: {
                    self.chooseImageAlert.view.superview?.subviews[0].isUserInteractionEnabled = true
                    self.chooseImageAlert.view.superview?.subviews[0].addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(self.dismissView)))
                })
            }
        }
        
    }
    
    @IBAction func genderMaleButtonWasTapped(_ sender: RoundedButton) {
        helper.checkAgeButtons(sender: sender, otherButtons: myGenderButtons)
        editedProfileModel.myGender = "1"
        
    }
    
    @IBAction func genderFemaleButtonWasTapped(_ sender: RoundedButton) {
        helper.checkAgeButtons(sender: sender, otherButtons: myGenderButtons)
        editedProfileModel.myGender = "0"
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
        datePickerContainer.frame = CGRect(x: 0.0, y: self.view.frame.height - 200, width: UIScreen.main.bounds.width, height: 200)
        datePicker.frame = CGRect(x: 0.0, y: 0, width: UIScreen.main.bounds.width, height: 200)
        //TODO: - SET CURRENT AGE OF THE USER
        guard let date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) else { return }
        datePicker.setDate(date, animated: true)
        datePicker.maximumDate = date
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(dateChangedInDate), for: UIControlEvents.valueChanged)
        datePickerContainer.backgroundColor = UIColor.white
        datePickerContainer.addSubview(datePicker)
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(Colors.male.color(), for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        doneButton.addTarget(self, action: #selector(dismissPicker), for: .touchUpInside)
        doneButton.frame = CGRect(x: UIScreen.main.bounds.width - 70, y: 5.0, width: 70.0, height: 37.0)
        datePickerContainer.addSubview(doneButton)
        self.view.addSubview(datePickerContainer)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dateChangedInDate(sender:UIDatePicker) {
        //TODO: - DECIDE THE FORMAT AND SAVE IN IT HERE
        //editedProfileModel.myAge = ""
        dateOfBirthButton.setTitle(helper.dateFormatter.string(from: sender.date), for: .normal)
    }

    @objc func dismissPicker(sender: UIButton) {
        datePickerContainer.removeFromSuperview()
    }
    
    @objc func dismissView() {
        chooseImageAlert.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper functions
    private func initialRetrieving() {
        guard let userInfo = self.localStorage.getUserInfo() else { return }
        editedProfileModel.myAge = userInfo.myAge
        editedProfileModel.myGender = userInfo.myGender
        editedProfileModel.nickname = userInfo.nickname
        editedProfileModel.telephone = userInfo.telephoneHash
        editedProfileModel.yourAge = userInfo.yourAge
        editedProfileModel.yourGender = userInfo.yourGender
        
        editedImageModel.image = userInfo.image
    }
    
    private func initialScreenSetup() {
        
    }
    
    private func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        userImageView.addGestureRecognizer(tap)
        userImageView.isUserInteractionEnabled = true
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        userImageView.image = image
        //TODO: - Bullshit
        guard let data = UIImageJPEGRepresentation(image, 1.0) else { return }
        editedImageModel.image = UIImageJPEGRepresentation(image, 1.0)?.base64EncodedString() ?? ""
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
