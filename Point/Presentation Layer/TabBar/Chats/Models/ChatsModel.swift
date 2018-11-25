//
//  ChatsModel.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

struct ChatsModel: Decodable {
    let chats: [Chat]
}

struct Chat: Decodable {
    let chatId: String
    let chatmade: ChatMade
    let initDate: String
    var messages: [Message]
}

struct Message: Decodable {
    let id: String
    let chatId: String
    let senderId: String
    let text: String
    let date: String
}

struct ChatMade: Decodable {
    let nick: String
    let id: String
}


// MARK: - Sorting
extension Sequence where Iterator.Element == Message {
    
    mutating func sort() {
        self = sorted(by: { (lhs, rhs) -> Bool in
            guard let lhsDate = Int(lhs.date) else { return false }
            guard let rhsDate = Int(rhs.date) else { return false }
            
            return lhsDate < rhsDate
        }) as! Self
    }
}
