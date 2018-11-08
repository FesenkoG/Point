//
//  AppDelegate.swift
//  Point
//
//  Created by Георгий Фесенко on 12/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let localStorage: ILocalStorage = LocalDataStorage()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().layer.shadowOffset = CGSize(width: 0, height: 2)
        UITabBar.appearance().shadowRadius = 7
        UITabBar.appearance().shadowColor = UIColor.black
        UITabBar.appearance().shadowOpacity = 0.07
        if let token = localStorage.getUserToken() {
            let requestSender: IRequestSender = RequestSender()
            requestSender.send(config: RequestFactory.AuthenticationRequest.getAuthByTokenConfig(token: token)) { (result) in
                switch result {
                case .error(let error):
                    guard let startViewController = self.getStartViewController() else { return }
                    self.window?.rootViewController = startViewController
                    startViewController.showErrorAlert(error)
                case .success(let res):
                    print(res.0)
                    guard let viewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController else { return }
                    viewController.selectedIndex = 1
                    self.configureTabBar(viewController)
                    self.window?.rootViewController = viewController
                }
            }
        } else {
            guard let startViewController = getStartViewController() else { return false }
            self.window?.rootViewController = startViewController
        }
        return true
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
}


