//
//  ChatsHistoryParser.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct ChatsHistoryParser: IParser {
    func parse(data: Data) -> ChatsModel? {
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let statusOne = json["status"] as? Bool, statusOne,
                let payload = json["payload"] as? [String: Any],
                let statusTwo = payload["status"] as? Bool, statusTwo,
                let data = payload["data"] else { return nil }
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            let chats = try JSONDecoder().decode(ChatsModel.self, from: jsonData)
            
            return chats
        } catch {
            print(error)
            return nil
        }
    }
}
