//
//  SettingsViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import StoreKit
import SkeletonView

class SettingsViewController: UIViewController {
    
    // MARK: - Private properties

    @IBOutlet private weak var avatarImageView: CircleImage!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userBioLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    @IBOutlet weak var circleView: CircleAroundImage!
    
    // Privacy
    @IBOutlet private weak var friendsView: UIView!
    @IBOutlet private weak var notificationsView: UIView!
    @IBOutlet private weak var privacyPolicyView: UIView!
    
    // About
    @IBOutlet private weak var contactUsView: UIView!
    @IBOutlet private weak var rateTheAppView: UIView!
    
    private let imageService: IImageService = ImageService()
    private let userService: IUserService = UserService()
    
    private lazy var skeletonableViews: [UIView] = [circleView, userNameLabel, userBioLabel, userPhoneNumberLabel]
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        configureGestureRecognizers()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        skeletonableViews.forEach {
            $0.showAnimatedGradientSkeleton()
        }
        
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        circleView.clipsToBounds = true
        
        userService.retrieveUserData { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let userData):
                
                // TODO: - This is not good
                guard let token = LocalStorage().getUserToken() else { return }
                let url = "\(BASE_URL)/getPhoto?&token=\(token)"
                guard let imageUrl = URL(string: url) else { return }
                self.avatarImageView.af_setImage(withURL: imageUrl, placeholderImage: UIImage.placeholderImage(), completion: { _ in
                    
                    self.userNameLabel.text = userData.nickname
                    if !userData.myBio.isEmpty {
                        self.userBioLabel.text = userData.myBio
                    }
                    self.userPhoneNumberLabel.text = userData.phone
                    self.skeletonableViews.forEach {
                        $0.hideSkeleton()
                    }
                })
                
            case .error(let error):
                self.showErrorAlert(error)
                
            }
        }
    }
    
    
    // MARK: - Private methods
    
    @objc private func didTapFriends() {
        
    }
    
    @objc private func didTapNotifications() {
        
    }
    
    @objc private func didTapPrivacyPolicy() {
        
    }
    
    @objc private func didTapContactUs() {
        
        let email = "foo@bar.com"
        
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func didTapRateTheApp() {
        SKStoreReviewController.requestReview()
    }
    
    
    private func configureGestureRecognizers() {
        friendsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFriends)))
        notificationsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapNotifications)))
        privacyPolicyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPrivacyPolicy)))
        contactUsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapContactUs)))
        rateTheAppView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRateTheApp)))
    }
}
