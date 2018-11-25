//
//  UserCreationParser.swift
//  Point
//
//  Created by Георгий Фесенко on 04.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct UserCreationParser: IParser {
    func parse(data: Data) -> String? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
            guard let payload = json["payload"] as? [String: Any] else { return nil }
            guard let data = payload["data"] as? [String: String], let token = data["token"], !token.isEmpty else { return nil }
            return token
        } catch {
            print(error)
            return nil
        }
    }
}
