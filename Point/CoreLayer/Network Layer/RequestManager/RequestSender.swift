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
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(Result.error("There is no data in the responce"))
                }
                return
            }
            if let error = parseStatus(data: data) {
                DispatchQueue.main.async {
                    completionHandler(Result.error(error))
                }
                return
            }
            guard let parsedModel: Parser.Model = config.parser.parse(data: data) else {
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

private func parseStatus(data: Data) -> String? {
    guard let jsonOptional = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let json = jsonOptional else {
        return nil
    }
    guard let statusOne = json["status"] as? Bool,
            let messageOne = json["message"] as? String,
    let payload = json["payload"] as? [String: Any],
    let statusTwo = payload["status"] as? Bool,
        let messageTwo = payload["message"] as? String else {
            return nil
    }
    if !statusOne { return messageOne }
    if !statusTwo { return messageTwo }
    return nil
}
