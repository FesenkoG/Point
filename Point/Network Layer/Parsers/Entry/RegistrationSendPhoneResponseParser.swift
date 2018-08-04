//
//  RegistrationSendPhoneResponseParser.swift
//  Point
//
//  Created by Георгий Фесенко on 03/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct RegistrationSendPhoneResponseParser: IParser {
    
    func parse(data: Data) -> Bool? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
            guard let statusOne = json["status"] as? Bool,
                let payload = json["payload"] as? [String: Any],
                let statusTwo = payload["status"] as? Bool else { return nil }
            return statusOne && statusTwo
        } catch {
            print(error)
            return nil
        }
    }
}
