//
//  AppDelegate.swift
//  Point
//
//  Created by Георгий Фесенко on 12/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Starscream

let ApplicationWillTerminateNotification = Notification.Name("ApplicationWillTerminate")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        window?.rootViewController = LaunchViewController()
        return true
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        NotificationCenter.default.post(Notification.init(name: ApplicationWillTerminateNotification))
    }
}


