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
    
    private let imageService: IImageService = ImageService()
    
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let token = LocalStorage().getUserToken() else { return }
        let url = "\(BASE_URL)/getPhoto?&token=\(token)"
        
        imageService.loadImage(url) { [weak self](result) in
            
            switch result {
            case .success(let image):
                self?.avatarImageView.image = image
            case .error(let error):
                self?.showErrorAlert(error)
            }
        }
    }
}
