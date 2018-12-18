//
//  SettingsViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Private properties

    @IBOutlet weak var avatarImageView: CircleImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    
    private let imageService: IImageService = ImageService()
    private let userService: IUserService = UserService()
    
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userService.retrieveUserData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let userData):
                self.userNameLabel.text = userData.nickname
                if !userData.myBio.isEmpty {
                    self.userBioLabel.text = userData.myBio
                }
            case .error(let error):
                self.showErrorAlert(error)
                
            }
        }
        
        imageService.loadUserImage { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.avatarImageView.image = image
            case .error(let error):
                self.showErrorAlert(error)
            }
        }
    }
}
