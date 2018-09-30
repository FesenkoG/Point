//
//  BlockedUser.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct BlockedUser: Codable {
    let friendId: String
    let friendNickname: String
    let friendPhoto: String
}
