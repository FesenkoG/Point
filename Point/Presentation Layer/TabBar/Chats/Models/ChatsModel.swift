//
//  ChatsModel.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct ChatsModel: Decodable {
    let chats: [Chat]
}

struct Chat: Decodable {
    let chatId: String
    let chatmade: String
    let initDate: String
    let messages: [Message]
}

struct Message: Decodable {
    let id: String
    let chatId: String
    let senderId: String
    let text: String
    let date: String
}
