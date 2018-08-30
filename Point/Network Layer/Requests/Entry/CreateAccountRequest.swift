//
//  CreateAccountRequest.swift
//  Point
//
//  Created by Георгий Фесенко on 04.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct CreateAccountRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(userData: NewUserModel) {
        guard let url = URL(string: BASE_URL + CREATE_ACCOUNT_URL_REGISTRATION) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = RequestPayload(payload: userData)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print(error)
            return
        }
        urlRequest = request
    }
}

struct RequestPayload<T: Codable>: Codable {
    let payload: T
}
