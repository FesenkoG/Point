//
//  RequestSender.swift
//  Point
//
//  Created by Георгий Фесенко on 01.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation
//MARK: - Done.
//TODO: Is it OK to take shared session...?
class RequestSender: IRequestSender {
    private let session = URLSession.shared
    
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.error("url string can't be parsed to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(Result.error(error.localizedDescription))
                }
                return
            }
            
            guard let data = data, let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                DispatchQueue.main.async {
                    completionHandler(Result.error("data can't be parsed"))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(Result.success(parsedModel))
            }
        }
        
        task.resume()
    }
}
