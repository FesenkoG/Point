//
//  LocalStorage.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation
import CoreData
import KeychainSwift

class LocalStorage: ILocalStorage {
    
    private let keychain = KeychainSwift()
    
    lazy var container: NSPersistentContainer = NSPersistentContainer(name: "CoreDataModel")
    private lazy var mainContext = self.container.viewContext
    
    init() {
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
    }
    
    
    //MARK: - This function either saves or rewrites data
    func saveUser(user: UserData, completion: @escaping (Error?) -> Void) {
        container.performBackgroundTask { (context) in
            let request = self.getUserFetchRequest()
            do {
                let results = try context.fetch(request)
                if results.count > 1 {
                    DispatchQueue.main.async {
                        completion(LocalStorageErrors.moreThanOneUserInTheStorage)
                    }
                } else if let currentUserData = results.first {
                    self.fulfillUser(currentUserData: currentUserData, user: user)
                    try context.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    guard let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else {
                        DispatchQueue.main.async {
                            completion(LocalStorageErrors.canNotInsertNewEntity)
                        }
                        return
                    }
                    self.fulfillUser(currentUserData: newUser, user: user)
                    try context.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func getUserInfo() -> UserData? {
        let request = getUserFetchRequest()
        do {
            guard let user = try mainContext.fetch(request).first else { return nil }
            return convertToNaviteStruct(contextUser: user)
        } catch {
            print(error)
            return nil
        }
    }
    
    func getUserToken() -> String? {
        return keychain.get("token")
    }
    
    func saveUserToken(_ token: String) {
        keychain.set(token, forKey: "token")
    }
    
    
    //MARK: - Private methods
    
    private func getUserFetchRequest() -> NSFetchRequest<User> {
        return User.fetchRequest()
    }
    
    private func fulfillUser(currentUserData: User, user: UserData) {
        currentUserData.date = user.date
        currentUserData.drink = user.drink
        currentUserData.eat = user.eat
        currentUserData.film = user.film
        //currentUserData.image = user.image
        currentUserData.myAge = user.myAge
        currentUserData.myBio = user.myBio
        currentUserData.myGender = user.myGender
        currentUserData.nickname = user.nickname
        currentUserData.sport = user.sport
        currentUserData.telephoneHash = user.telephoneHash
        currentUserData.walk = user.walk
        currentUserData.yourAge = user.yourAge
        currentUserData.yourGender = user.yourGender
    }
    
    private func convertToNaviteStruct(contextUser: User) -> UserData {
        return UserData(telephoneHash: contextUser.telephoneHash ?? "", nickname: contextUser.nickname ?? "", myBio: contextUser.myBio ?? "", myAge: contextUser.myAge ?? "", myGender: contextUser.myGender ?? "", yourGender: contextUser.yourGender ?? "", yourAge: contextUser.yourAge ?? "", eat: contextUser.eat ?? "", drink: contextUser.drink ?? "", film: contextUser.film ?? "", sport: contextUser.sport ?? "", date: contextUser.date ?? "", walk: contextUser.walk ?? "")
    }
    
}

enum LocalStorageErrors: Error {
    case moreThanOneUserInTheStorage
    case canNotInsertNewEntity
}
