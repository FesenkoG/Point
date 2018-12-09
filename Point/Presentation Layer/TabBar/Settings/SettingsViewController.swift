//
//  SettingsViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: CircleImage!
    
    
    // MARK: - Private properties
    
    private let imageService: IImageService = ImageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let token = LocalDataStorage().getUserToken() else { return }
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
