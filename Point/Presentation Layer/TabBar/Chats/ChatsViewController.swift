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
        chats = [Chat(chatId: "12", chatmade: "Gleb", initDate: "21-22-23", messages: [Message(id: "23", chatId: "21", senderId: "23", text: "Hello, glyab!Lalalalalalalalallaasdasdaskdl;sahf;osdhgoahgiuhefiguhdfisuhvidsfuhviudhsfivudfiluvidfunvidfunvidusnvidusfnivdunfsivdunfsivudnsfivdufnvidusnfvisdufnvidsufnvidfsunvidfsunvidsufnviudsfunvidsfunvidsufnviodsunviodsunviosdufnvidsounviopdsunfivpdsunfovdisfopigfopaigopdfihgo;sdfh;sdfkhgl;afkjgpoeajig[ieprhjgo;dfigo;ishopierhgo;dfingoeirhg'fdgo[ierhiqg'fidghoeihrg'afidhgo;adfgi;odfahgp'sdfiho;iafdgp'idahfgo'iafdjgh'ioafhgp'erh[oirqehioytoirewhg;dlfkng/lkadsng", date: "21.10.2018"), Message(id: "2", chatId: "2", senderId: "2", text: "Hello!", date: "22-21")])]
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
