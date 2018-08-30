//
//  SubmitFriendRequest.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct SubmitFriendRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(token: String, userId: String, type: FriendRequestType) {
        guard let url = URL(string: BASE_URL + (type == .submit ? SUBMIT_FRIEND_URL_FRIENDS: DELETE_FRIEND_URL_FRIENDS)) else { return }
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

enum FriendRequestType {
    case submit
    case delete
}
