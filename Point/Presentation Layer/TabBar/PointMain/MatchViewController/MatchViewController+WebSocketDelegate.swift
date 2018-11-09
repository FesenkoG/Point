//
//  MatchViewController+WebSocketDelegate.swift
//  Point
//
//  Created by NewUser on 29/09/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation
import Starscream

extension MatchViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print(socket)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print(error)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let text = String(text.filter { !" \n\t\r".contains($0) })
        
        switch text {
        case "true", "True":
            print("TODO: - Navigate to chat screen")
            guard let chatVC = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController else { return }
            chatVC.yourID = userID
            pointNavigation?.pushViewController(chatVC, animated: true)
            self.dismiss(animated: false, completion: nil)
        case "false", "Flase":
            self.dismiss(animated: false, completion: nil)
            print("TODO: - Dismiss controller, switch to the next user.")
        default:
            print("well, thats not good.")
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(data)
    }
}
