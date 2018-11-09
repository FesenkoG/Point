//
//  LaunchViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 09/11/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    
    private let localStorage: ILocalStorage = LocalDataStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoadingAnimation()
        UITabBar.appearance().layer.shadowOffset = CGSize(width: 0, height: 2)
        UITabBar.appearance().shadowRadius = 7
        UITabBar.appearance().shadowColor = UIColor.black
        UITabBar.appearance().shadowOpacity = 0.07
        if let token = self.localStorage.getUserToken() {
            let requestSender: IRequestSender = RequestSender()
            requestSender.send(config: RequestFactory.AuthenticationRequest.getAuthByTokenConfig(token: token)) { (result) in
                switch result {
                case .error(let error):
                    guard let startViewController = self.getStartViewController() else { return }
                    self.animateTransition(toViewController: startViewController)
                    startViewController.showErrorAlert(error)
                case .success(let res):
                    print(res.0)
                    guard let viewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController else { return }
                    viewController.selectedIndex = 1
                    self.configureTabBar(viewController)
                    self.animateTransition(toViewController: viewController)
                }
            }
        } else {
            guard let startViewController = self.getStartViewController() else { return }
            self.animateTransition(toViewController: startViewController)
        }
    }
    
    
    // MARK: - Private methods
    
    private func startLoadingAnimation() {
        loadingView.layer.cornerRadius = 3
        loadingView.clipsToBounds = true
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 3))
        path.addLine(to: CGPoint(x: loadingView.frame.width, y: 3))
        
        // create shape layer for that path
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0.8196078431, green: 0.337254902, blue: 0.6352941176, alpha: 1)
        shapeLayer.lineWidth = 10
        shapeLayer.path = path.cgPath
        
        // animate it
        loadingView.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 10
        shapeLayer.add(animation, forKey: "MyAnimation")
    }
    
    private func configureTabBar(_ tabBarController: UITabBarController) {
        let tabBar = tabBarController.tabBar
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBarController.viewControllers?.forEach({ (controller) in
            controller.tabBarItem.setImageInsets()
        })
    }
    
    private func getStartViewController() -> UINavigationController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "startNavigationController") as? UINavigationController
    }
    
    private func animateTransition(toViewController vc: UIViewController) {
        let newView = vc.view!
        newView.alpha = 0
        view.addSubview(newView)
        
        UIView.animate(withDuration: 0.5, animations: {
            newView.alpha = 1.0
        }) { (_) in
            newView.removeFromSuperview()
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
    
}
