//
//  SendPhoneRequest.swift
//  Point
//
//  Created by Георгий Фесенко on 03/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

enum LoginType {
    case registration
    case authorisation
}

struct SendPhoneRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(phoneNumber: String, type: LoginType) {
        let urlTyped = type == .registration ? SEND_PHONE_URL_REGISTRATION : SEND_PHONE_URL_AUTHORISATION
        guard let url = URL(string: BASE_URL + urlTyped) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["payload": ["phone": phoneNumber]], options: [])
        } catch {
            print(error)
            return
        }
        urlRequest = request
    }
}
