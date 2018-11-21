//
//  ConversationViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 12.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import Starscream

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var chat: Chat!
    var yourID: String!
    var socket: WebSocket!
    
    private let localStorage: ILocalStorage = LocalDataStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextView.delegate = self
        
        guard let token = localStorage.getUserToken() else { return }
        guard let url = URL(string: "\(SOCKET_URL)/chat?token=\(token)&yourId=\(yourID ?? "0")") else { return }
        socket = WebSocket(url: url)
        socket.delegate = self
        socket.connect()
        titleLabel.text = chat.chatmade.nick
        setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboadNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboadNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboadNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            bottomConstraint.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                let number = self.chat.messages.count
                if number > 0 {
                    let indexPath = IndexPath(row: number - 1 , section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        socket?.disconnect()
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func emojiButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        guard let text = messageTextView.text else { return }
        socket.write(string: text)
        let msg = Message(id: "12", chatId: "12", senderId: "heh", text: text, date: "13.10.1997")
        chat.messages.append(msg)
        tableView.reloadData()
    }
    
    //MARK: - Table View Delegate/Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: - check for message type
        let message = chat.messages[indexPath.row]
        
        if message.senderId == yourID {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingCell") as? IncomingCell else { return UITableViewCell() }
            cell.configure(message)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingCell") as? OutgoingCell else { return UITableViewCell() }
            cell.configure(message)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension ConversationViewController: WebSocketDelegate {
    
    func websocketDidConnect(socket: WebSocketClient) {
        print(socket)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print(error?.localizedDescription)
    }
    
    /*
     приходящее сообщение
     {
     "id":"10",
     "chatId":"1",
     "senderId":"1",
     "text":"1",
     "date":"Wednesday, 08-Aug-18 05:32:17 MSK"
     }
    */
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let data = text.data(using: .utf8) else { return }
        do {
            let message = try JSONDecoder().decode(Message.self, from: data)
            chat.messages.append(message)
            tableView.reloadData()
            let indexPathToScroll = IndexPath(row: chat.messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPathToScroll, at: .bottom, animated: true)
        } catch {
            print(error)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(String(data: data, encoding: .utf8))
    }
}


extension ConversationViewController: UITextViewDelegate {
    
}
