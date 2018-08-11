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
        let v = view.subviews.first { (view) -> Bool in
            if let _ = view as? UIVisualEffectView {
                return true
            }
            return false
        }
        v?.removeFromSuperview()
    }
    
    @IBAction func pointButtonTapped(_ sender: UIButton) {
        let matchVC = MatchViewController()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        matchVC.modalPresentationStyle = .custom
        navigationController?.pushViewController(matchVC, animated: false)
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

