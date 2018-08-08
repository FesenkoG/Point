//
//  PointViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class PointViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
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

