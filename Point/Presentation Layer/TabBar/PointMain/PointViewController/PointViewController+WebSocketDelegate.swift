//
//  PointViewController+SocketDelegate.swift
//  Point
//
//  Created by NewUser on 29/09/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation
import Starscream

extension PointViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print(socket)
        isSearching = true
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        self.showErrorAlert(error?.localizedDescription ?? "Error!")
        isSearching = false
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print(text)
        do {
            guard let data = text.data(using: .utf8) else { return }
            guard var json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
            guard let id = json["id"] else { return }
            print(id)
            json["id"] = nil
            print(json)
            let dataToDecode = try JSONSerialization.data(withJSONObject: json as Any, options: [])
            let user = try JSONDecoder().decode(UserData.self, from: dataToDecode)
            let matchViewController = MatchViewController(userID: id, user: user, socket: self.socket)
            matchViewController.pointNavigation = navigationController
            matchViewController.modalPresentationStyle = .custom
            self.present(matchViewController, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(data)
    }
    
}
