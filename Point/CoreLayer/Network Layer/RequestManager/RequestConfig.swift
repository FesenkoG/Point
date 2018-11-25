//
//  RequestConfig.swift
//  Point
//
//  Created by Георгий Фесенко on 01.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}
