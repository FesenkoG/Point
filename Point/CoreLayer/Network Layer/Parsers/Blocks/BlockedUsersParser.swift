//
//  BlockedUsersParser.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct BlockedUsersParser: IParser {
    func parse(data: Data) -> [BlockedUser]? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let statusOne = json["status"] as? Bool, statusOne,
                let payload = json["payload"] as? [String: Any],
                let statusTwo = payload["status"] as? Bool, statusTwo,
            let data = payload["data"] as? [String: Any],
                let blocks = data["blocks"] as? Data else { return nil }
            let blockedUsers = try JSONDecoder().decode([BlockedUser].self, from: blocks)
            return blockedUsers
        } catch {
            print(error)
            return nil
        }
        
    }
}
