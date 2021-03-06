//
//  SubmitSmsRequest.swift
//  Point
//
//  Created by Георгий Фесенко on 03/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct SubmitSmsRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(phoneNumber: String, sms: String) {
        
        guard let url = URL(string: BASE_URL + SUBMIT_SMS_URL_AUTHORISATION) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["payload": ["phone": phoneNumber, "sms": sms]], options: [])
        } catch {
            print(error)
            return
        }
        urlRequest = request
    }
}
