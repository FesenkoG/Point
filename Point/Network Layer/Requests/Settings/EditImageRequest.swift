//
//  EditImageRequest.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct EditImageRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(newImage: EditedImageModel) {
        guard let url = URL(string: BASE_URL + EDIT_PROFILE_IMAGE_URL_SETTINGS) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["payload": newImage], options: [])
        } catch {
            print(error)
        }
        
        urlRequest = request
    }
}
