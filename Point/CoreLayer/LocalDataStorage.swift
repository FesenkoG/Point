//
//  LocalDataStorage.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation
import CoreData

class LocalDataStorage {
    
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
            
        }
    }
    
    func getUserInfo() -> UserData {
        
    }
    
}
