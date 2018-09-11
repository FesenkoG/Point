//
//  PointViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class PointViewController: UIViewController {
    
    @IBOutlet weak var pointButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func pointButtonTapped(_ sender: UIButton) {
        let matchVC = MatchViewController()
        
        matchVC.modalPresentationStyle = .custom
        present(matchVC, animated: true, completion: nil)
    }
    
    //TODO: - Move this to AppDelegate
    private func configureTabBar() {
        guard let tabBar = tabBarController?.tabBar else { return }
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBarController?.viewControllers?.forEach({ (controller) in
            controller.tabBarItem.setImageInsets()
        })
    }
}

