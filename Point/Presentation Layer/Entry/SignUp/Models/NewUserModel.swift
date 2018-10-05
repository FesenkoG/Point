//
//  UserInfoModel.swift
//  Point
//
//  Created by Георгий Фесенко on 28.07.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct NewUserModel: Codable {
    var phone: String = ""
    var sms: String = ""
    var nickname: String = ""
    var myAge: String = ""
    var myGender: String = ""
    var yourAge: String = "18-99"
    var yourGender: String = "-1"
}
