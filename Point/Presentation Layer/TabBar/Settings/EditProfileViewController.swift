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
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userBioTextView: UITextView!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    
    private let helper = Utils()
    private let settingsService: ISettingsService = SettingsService()
    private let localStorage: ILocalStorage = LocalStorage()
    private let imageService: IImageService = ImageService()
    private let userService: IUserService = UserService()
    
    
    //MARK: - Variables
    
    private var editedProfileModel = EditedProfileModel()
    private let datePickerContainer = UIView()
    private let datePicker = UIDatePicker()
    private var chooseImageAlert: UIAlertController!
    private lazy var imagePicker = UIImagePickerController()
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userBioTextView.backgroundColor = .clear
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackground)))
        guard let token = localStorage.getUserToken() else { return }
        editedProfileModel.token = token
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        initialRetrieving()
        setupGestureRecognizers()
    }
    
    
    // MARK: - Private methods
    
    @IBAction private func saveButtonWasTapped(_ sender: Any) {
        editedProfileModel.nickname = userNameTextField.text ?? "Self"
        editedProfileModel.myBio = userBioTextView.text ?? ""
        settingsService
            .sendEditedProfile(model: editedProfileModel) { (result) in
                
                switch result {
                    
                case .error(let error):
                    self.showErrorAlert(error)
                case .success(let result):
                    if result {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
        }
    }
    
    
    @objc private func didTapPhoto() {
        
        userImageView.isUserInteractionEnabled = false
        
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
        
        
        let configureAlert = { (isCameraAllowed: Bool) in
            DispatchQueue.main.async {
                if isCameraAllowed {
                    self.chooseImageAlert.addAction(photoAction)
                }
                self.chooseImageAlert.addAction(galleryAction)
                self.userImageView.isUserInteractionEnabled = true
                
                self.present(self.chooseImageAlert,
                             animated: true,
                             completion: nil)
            }
        }
        
        let cameraUsageStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraUsageStatus {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: configureAlert)
        case .restricted:
            configureAlert(false)
        case .denied:
            userImageView.isUserInteractionEnabled = true
            showAskForSettingsChangeAlert(completion: configureAlert)
        case .authorized:
            configureAlert(true)
        }
        
    }
    
    private func showAskForSettingsChangeAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Would you like to capture a photo?", message: "Please, go to settings and give needed permissions", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Go to settings", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            completion(false)
        }
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
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
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(dateChangedInDate), for: UIControl.Event.valueChanged)
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
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        
        localStorage.clearUserInfo()
        
        let vc = helper.getSignUpViewController()
        UIApplication.shared.keyWindow?.rootViewController = vc
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
        
        userService.retrieveUserData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let userInfo):
                
                self.editedProfileModel.myAge = userInfo.myAge
                self.editedProfileModel.myGender = userInfo.myGender
                self.editedProfileModel.nickname = userInfo.nickname
                self.editedProfileModel.myBio = userInfo.myBio
                self.editedProfileModel.yourAge = userInfo.yourAge
                self.editedProfileModel.yourGender = userInfo.yourGender
                
                self.userNameTextField.text = userInfo.nickname
                self.userBioTextView.text = userInfo.myBio.isEmpty ? "Write a few words about yourself" : userInfo.myBio
                self.userPhoneNumberLabel.text = userInfo.phone
                
                guard let timeInterval = TimeInterval(userInfo.myAge) else { return }
                let date = Date(timeIntervalSince1970: timeInterval)
                self.dateOfBirthButton.setTitle(self.helper.dateFormatter.string(from: date), for: .normal)
                
                
                // My gender buttons
                switch userInfo.myGender {
                    
                case "1":
                    guard let maleButton = self.myGenderButtons.first  else { return }
                    self.helper.checkAgeButtons(sender: maleButton,
                                                otherButtons: self.myGenderButtons)
                case "0":
                    guard let femaleButton = self.myGenderButtons.last else { return }
                    self.helper.checkAgeButtons(sender: femaleButton,
                                                otherButtons: self.myGenderButtons)
                default:
                    break
                }
                
                // Preferred gender buttons
                var yourGenderSelectedIndex: Int
                switch userInfo.yourGender {
                case "1":
                    yourGenderSelectedIndex = 0
                case "0":
                    yourGenderSelectedIndex = 1
                default:
                    yourGenderSelectedIndex = 2
                }
                
                self.helper.checkGenderButtons(index: yourGenderSelectedIndex,
                                               images: self.genderOkImages,
                                               labels: self.genderLabels)
                
                //Preferred age buttons
                var yourAgeSelectedIndex: Int
                switch userInfo.yourAge {
                case "18-22":
                    yourAgeSelectedIndex = 0
                case "23-27":
                    yourAgeSelectedIndex = 1
                case "28-35":
                    yourAgeSelectedIndex = 2
                case "36-45":
                    yourAgeSelectedIndex = 3
                case "46-99":
                    yourAgeSelectedIndex = 4
                default:
                    yourAgeSelectedIndex = 5
                }
                
                let ageSelectedButton = self.ageButtons[yourAgeSelectedIndex]
                self.helper.checkAgeButtons(sender: ageSelectedButton, otherButtons: self.ageButtons)

                
                
            case .error(let error):
                self.showErrorAlert(error)
            }
        }
        
        // User image uploading
        guard let token = LocalStorage().getUserToken() else { return }
        let url = "\(BASE_URL)/getPhoto?&token=\(token)"
        guard let imageUrl = URL(string: url) else { return }
        self.userImageView.af_setImage(withURL: imageUrl,placeholderImage: UIImage.placeholderImage())
    }
    
    private func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        userImageView.addGestureRecognizer(tap)
        userImageView.isUserInteractionEnabled = true
    }
    
    @objc private func didTapBackground() {
        userNameTextField.resignFirstResponder()
        userBioTextView.resignFirstResponder()
    }
}


// MARK: - UIImagePicketControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else { return }
        userImageView.image = image
        
        imageService.upload(image: image) { (error) in
            if let error = error?.localizedDescription {
                self.showErrorAlert(error)
            } else {
                self.showErrorAlert("Photo successfully uploaded")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
