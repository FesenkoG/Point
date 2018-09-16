//
//  ConversationViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 12.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    var chat: Chat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = chat.chatmade
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func emojiButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        
    }
    
    //MARK: - Table View Delegate/Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: - check for message type
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingCell") as? IncomingCell else { return UITableViewCell() }
            cell.configure(chat.messages[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingCell") as? OutgoingCell else { return UITableViewCell() }
            cell.configure(chat.messages[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

