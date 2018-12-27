//
//  ChatsViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var noMessagesView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var chats: [Chat] = []
    private let chatService: IChatService = ChatService()
    private let localStorage: ILocalStorage = LocalStorage()
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVisibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveChats()
    }
    
    
    // MARK: - Private methods
    
    private func retrieveChats() {
        
        chatService.retrieveChatsForUser { (result) in
            switch result {
            case .success(let chats):
                self.chats = chats
                self.tableView.reloadData()
                self.configureVisibility()
            case .error(let error):
                self.showErrorAlert(error)
                self.configureVisibility()
            }
        }
        
    }
    
    private func configureVisibility() {
        noMessagesView.isHidden = chats.count > 0
        tableView.isHidden = !noMessagesView.isHidden
    }
    
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let conversationViewController = segue.destination as? ConversationViewController, let chat = sender as? Chat {
            
            var yourId: String?
            
            if chat.chatmade.nick != localStorage.getUserInfo()?.nickname {
                yourId = chat.chatmade.id
            } else {
                yourId = chat.messages.first(where: { $0.senderId != chat.chatmade.id })?.senderId
            }
            
            conversationViewController.chat = chat
            conversationViewController.yourID = yourId ?? "0"
            conversationViewController.isLoadFromMatchScreen = false
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension ChatsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as? ChatCell else { return UITableViewCell() }
        
        let chat = chats[indexPath.row]
        
        var yourId: String?
        
        if chat.chatmade.nick != localStorage.getUserInfo()?.nickname {
            yourId = chat.chatmade.id
        } else {
            yourId = chat.messages.first(where: { $0.senderId != chat.chatmade.id })?.senderId
        }
        guard let token = localStorage.getUserToken() else { return UITableViewCell() }
        let url = URL(string: "\(BASE_URL)/getPhoto?&token=\(token)&userId=\(yourId ?? "0")")

        cell.configure(chat, imageUrl: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowConversation", sender: chats[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
