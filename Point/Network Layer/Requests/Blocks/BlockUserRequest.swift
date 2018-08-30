//
//  BlockUserRequest.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct BlockUserRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(token: String, userId: String, type: RequestBlockType) {
        guard let url = URL(string:  BASE_URL + (type == .block ? BLOCK_USER_URL_BLOCKS : UNBLOCK_USER_URL_BLOCKS)) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["payload": ["token": token, "userid": userId]], options: [])
        } catch {
            print(error)
        }
        urlRequest = request
    }
}

enum RequestBlockType {
    case block
    case unblock
}
