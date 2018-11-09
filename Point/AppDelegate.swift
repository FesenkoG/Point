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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        //window?.rootViewController = LaunchViewController()
        let socket = WebSocket(url: URL(string: "https://hello.com")!)
        let userData = UserData(telephoneHash: "", nickname: "", myBio: "", myAge: "", myGender: "", yourGender: "", yourAge: "", eat: "", drink: "", film: "", sport: "", date: "", walk: "")
        let match = MatchViewController(userID: "1", user: userData, socket: socket)
        window?.rootViewController = match
        return true
    }
}


