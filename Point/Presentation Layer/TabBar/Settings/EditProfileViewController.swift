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
    
    // MARK: - Private methods
    
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private var ageButtons: [RoundedButton]!
    @IBOutlet private var genderButtons: [UIButton]!
    @IBOutlet private var genderLabels: [UILabel]!
    @IBOutlet private var genderOkImages: [UIImageView]!
    @IBOutlet private var myGenderButtons: [RoundedButton]!
    @IBOutlet private weak var dateOfBirthButton: UIButton!
    @IBOutlet private weak var userImageView: CircleImage!
    
    private let helper = Utils()
    private let settingsService: ISettingsService = SettingsService()
    private let localStorage: ILocalStorage = LocalStorage()
    private let imageService: IImageService = ImageService()
    
    
    //MARK: - Variables
    
    private var editedProfileModel = EditedProfileModel()
    private var editedImageModel = EditedImageModel()
    private let datePickerContainer = UIView()
    private let datePicker = UIDatePicker()
    private var chooseImageAlert: UIAlertController!
    private lazy var imagePicker = UIImagePickerController()
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let token = localStorage.getUserToken() else { return }
        editedProfileModel.token = token
        editedImageModel.token = token
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        initialRetrieving()
        setupGestureRecognizers()
    }
    
    
    // MARK: - Private methods
    
    @IBAction private func saveButtonWasTapped(_ sender: Any) {
        
        settingsService
            .sendEditedProfile(model: editedProfileModel) { (result) in
                
            switch result {
                
            case .error(let error):
                self.showErrorAlert(error)
            case .success(let result):
                if result {
                    self.settingsService
                        .sendEditedImage(model:
                        self.editedImageModel, completion: { (result) in
                            
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
    
    
    @objc private func didTapPhoto() {
        
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
        
        AVCaptureDevice.requestAccess(for: .video) { response in
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
    
    @IBAction private func genderMaleButtonWasTapped(_ sender: RoundedButton) {
        helper.checkAgeButtons(sender: sender, otherButtons: myGenderButtons)
        editedProfileModel.myGender = "1"
        
    }
    
    @IBAction private func genderFemaleButtonWasTapped(_ sender: RoundedButton) {
        helper.checkAgeButtons(sender: sender, otherButtons: myGenderButtons)
        editedProfileModel.myGender = "0"
    }
    
    @IBAction private func ageButtonTapped(_ sender: RoundedButton) {
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
    
    @IBAction private func preferredGenderButtonTapped(_ sender: UIButton) {
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
    
    @IBAction private func chooseDateOfBirthWasTapped(_ sender: Any) {
        datePickerContainer.frame = CGRect(x: 0.0, y: self.view.frame.height - 200, width: UIScreen.main.bounds.width, height: 200)
        datePicker.frame = CGRect(x: 0.0, y: 0, width: UIScreen.main.bounds.width, height: 200)

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
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dateChangedInDate(sender: UIDatePicker) {
        editedProfileModel.myAge = String(describing: Int(sender.date.timeIntervalSince1970))
        dateOfBirthButton.setTitle(helper.dateFormatter.string(from: sender.date), for: .normal)
    }

    @objc private func dismissPicker(sender: UIButton) {
        datePickerContainer.removeFromSuperview()
    }
    
    @objc private func dismissView() {
        chooseImageAlert.dismiss(animated: true, completion: nil)
    }
    
    private func initialRetrieving() {
        guard let userInfo = self.localStorage.getUserInfo() else { return }
        editedProfileModel.myAge = userInfo.myAge
        editedProfileModel.myGender = userInfo.myGender
        editedProfileModel.nickname = userInfo.nickname
        editedProfileModel.telephone = userInfo.telephoneHash
        editedProfileModel.yourAge = userInfo.yourAge
        editedProfileModel.yourGender = userInfo.yourGender
        
    }
    
    private func initialScreenSetup() {
        
    }
    
    private func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        userImageView.addGestureRecognizer(tap)
        userImageView.isUserInteractionEnabled = true
    }
}


// MARK: - UIImagePicketControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        userImageView.image = image
        
        imageService.upload(image: image) { (url) in
            print(url)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
