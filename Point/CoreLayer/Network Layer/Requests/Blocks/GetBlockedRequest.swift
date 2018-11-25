//
//  GetBlockedRequest.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct GetBlockedRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(token: String) {
        guard let url = URL(string: BASE_URL + GET_BLOCKED_USERS_URL_BLOCKS) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["payload": ["token": token]], options: [])
        } catch {
            print(error)
        }
        urlRequest = request
    }
}
