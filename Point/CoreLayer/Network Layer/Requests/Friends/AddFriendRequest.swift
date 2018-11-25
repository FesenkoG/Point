//
//  AddFriendRequest.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct AddFriendRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(token: String, phoneNumber: String) {
        guard let url = URL(string: BASE_URL + ADD_FRIEND_URL_FRIENDS) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["payload": ["token": token, "phone": phoneNumber]], options: [])
        } catch {
            print(error)
        }
        urlRequest = request
    }
}
