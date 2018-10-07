//
//  EditedProfileModel.swift
//  Point
//
//  Created by Георгий Фесенко on 30/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct EditedProfileModel: Codable {
    var token: String = ""
    var telephone: String = ""
    var nickname: String = ""
    var myAge: String = ""
    var myGender: String = ""
    var yourAge: String = "18-99"
    var yourGender: String = "-1"
}
