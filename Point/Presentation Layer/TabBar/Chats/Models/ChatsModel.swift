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
    let photo: String
}
