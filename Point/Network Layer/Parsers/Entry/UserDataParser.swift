//
//  UserDataParser.swift
//  Point
//
//  Created by Георгий Фесенко on 04.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct UserDataParser: IParser {
    func parse(data: Data) -> UserData? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
            guard let payload = json["payload"] as? [String: Any], let data = payload["data"] as? [String: Any], let userData = data["userData"] as? [String: Any] else { return nil }
            
            let dataUserData = try JSONSerialization.data(withJSONObject: userData, options: [])
            let realUserData = try JSONDecoder().decode(UserData.self, from: dataUserData)
            return realUserData
        } catch {
            print(error)
            return nil
        }
    }
}

struct UserData: Codable {
    let telephoneHash: String
    let nickname: String
    let myBio: String
    let myAge: String
    let myGender: String
    let image: String
    let yourGender: String
    let yourAge: String
    let eat: String
    let drink: String
    let film: String
    let sport: String
    let date: String
    let walk: String
}
