//
//  File.swift
//  Point
//
//  Created by Георгий Фесенко on 01.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}
