//
//  CheckTokenRequest.swift
//  Point
//
//  Created by Георгий Фесенко on 03/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct CheckTokenRequest: IRequest {
    var urlRequest: URLRequest?
    
    init() {
        guard let url = URL(string: BASE_URL + CHECK_TOKEN_URL_AUTHORISATION) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //TODO: Retreive token from local storage.
        let token = "1"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["payload": ["token": token]], options: [])
        } catch {
            print(error)
            return
        }
        
        urlRequest = request
    }
}
