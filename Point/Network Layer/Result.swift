//
//  Result.swift
//  Point
//
//  Created by Георгий Фесенко on 01.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

enum Result<T> {
    case success(T)
    case error(String)
}

