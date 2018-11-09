//
//  SettingsService.swift
//  Point
//
//  Created by Георгий Фесенко on 09/11/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

protocol ISettingsService {
    func sendEditedProfile(model: EditedProfileModel, completion: @escaping (Result<Bool>) -> Void)
    func sendEditedImage(model: EditedImageModel, completion: @escaping (Result<Bool>) -> Void)
}

class SettingsService: ISettingsService {
    
    private let requestSender: IRequestSender = RequestSender()
    
    
    func sendEditedProfile(model: EditedProfileModel, completion: @escaping (Result<Bool>) -> Void) {
        
        requestSender.send(config: RequestFactory.SettingsRequests.getEditProfileConfig(newProfile: model), completionHandler: completion)
    }
    
    func sendEditedImage(model: EditedImageModel, completion: @escaping (Result<Bool>) -> Void) {
        
        requestSender.send(config: RequestFactory.SettingsRequests.getEditImageConfig(newImage: model), completionHandler: completion)
    }
    
}
