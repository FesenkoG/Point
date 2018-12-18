//
//  UserService.swift
//  Point
//
//  Created by Георгий Фесенко on 18/12/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

protocol IUserService {
    func retrieveUserData(completion: @escaping (Result<UserData>) -> Void)
}

final class UserService: IUserService {
    
    private let localStorage: ILocalStorage = LocalStorage()
    private let requestSender: IRequestSender = RequestSender()
    
    func retrieveUserData(completion: @escaping (Result<UserData>) -> Void) {
        
        guard let token = localStorage.getUserToken() else {
            completion(Result.error("Can not retrieve user token from local storage."))
            return
        }
        
        requestSender.send(
            config: RequestFactory
                .AuthenticationRequest
                .getAuthByTokenConfig(token: token)) { (result) in
                    
                    switch result {
                        
                    case .success(let result):
                        completion(Result.success(result.0))
                    case .error(let error):
                        completion(Result.error(error))
                    }
                    
        }
    }
}
