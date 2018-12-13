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
            conversationViewController.chat = chat
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
        cell.configure(chats[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowConversation", sender: chats[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
