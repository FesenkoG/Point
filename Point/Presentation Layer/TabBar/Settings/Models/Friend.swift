//
//  Friend.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct AllFriends: Codable {
    let friends: [Friend]
    let friendsOffers: [Friend]
}

struct Friend: Codable {
    let friendId: String
    let friendNickname: String
}
