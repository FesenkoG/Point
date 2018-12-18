//
//  ILocalStorage.swift
//  Point
//
//  Created by Георгий Фесенко on 13/12/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

protocol ILocalStorage {
    func saveUser(user: UserData, completion: @escaping (Error?) -> Void)
    func getUserInfo() -> UserData?
    func getUserToken() -> String?
    func saveUserToken(_ token: String)
    func clearUserInfo()
}
