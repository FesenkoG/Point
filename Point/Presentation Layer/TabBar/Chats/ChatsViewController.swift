//
//  ChatsViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noMessagesView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var chats: [Chat] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        noMessagesView.isHidden = chats.count > 0
        tableView.isHidden = !noMessagesView.isHidden
    }
    
    
    //MARK: - Table View Delegate/Data Source
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
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let conversationViewController = segue.destination as? ConversationViewController, let chat = sender as? Chat {
            conversationViewController.chat = chat
        }
    }
}
