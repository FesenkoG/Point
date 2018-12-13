//
//  ChatService.swift
//  Point
//
//  Created by Георгий Фесенко on 25/11/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

protocol IChatService {
    func retrieveChatsForUser(completion: @escaping (Result<[Chat]>) -> Void)
}


class ChatService: IChatService {
    
    private let requestSender: IRequestSender = RequestSender()
    private let localStorage: ILocalStorage = LocalStorage()
    
    func retrieveChatsForUser(completion: @escaping (Result<[Chat]>) -> Void) {
        guard let token = localStorage.getUserToken() else { return }

        requestSender.send(config: RequestFactory.ChatsRequests.getChatsHistoryConfig(token: token)) { (result) in
            switch result {
            case .success(let chatsModel):
                completion(Result.success(chatsModel.chats))
            case .error(let error):
                completion(Result.error(error))
            }
        }
        
    }
}
