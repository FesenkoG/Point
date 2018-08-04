//
//  IRequestSender.swift
//  Point
//
//  Created by Георгий Фесенко on 01.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

//MARK: - Done.
protocol IRequestSender {
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void)
}
