//
//  ChangeLocationRequest.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct ChangeLocationRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(token: String, location: Location) {
        guard let url = URL(string: BASE_URL + CHANGE_POSITION_URL_LOCATION) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["payload": ["token": token, "location": ["longitude": location.longitude, "latitude": location.latitude]]], options: [])
        } catch {
            print(error)
        }
        urlRequest = request
    }
}

struct Location: Codable {
    let longitude: String
    let latitude: String
}
