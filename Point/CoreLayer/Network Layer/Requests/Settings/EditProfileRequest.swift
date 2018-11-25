//
//  EditProfileRequest.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct EditProfileRequset: IRequest {
    var urlRequest: URLRequest?
    
    init(newProfile: EditedProfileModel) {
        guard let url = URL(string: BASE_URL + EDIT_PROFILE_URL_SETTINGS) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            
            request.httpBody = try JSONEncoder().encode(RequestPayload<EditedProfileModel>(payload: newProfile))
        } catch {
            print(error)
        }
        
        urlRequest = request
    }
}
