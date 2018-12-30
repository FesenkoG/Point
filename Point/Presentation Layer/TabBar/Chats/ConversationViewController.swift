//
//  ConversationViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 12.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import Starscream

class ConversationViewController: UIViewController {
    
    // MARK: - Public properties
    
    var chat: Chat!
    var yourID: String = "0"
    var socket: WebSocket!
    var isLoadFromMatchScreen: Bool = true
    
    
    // MARK: - Private properties
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var messageTextView: UITextView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textInputView: UIView!
    private let localStorage: ILocalStorage = LocalStorage()
    private var userId: String?
    private var shouldShowDisconnectAlert: Bool = true
    
    private lazy var myImageUrl: URL? = {
        guard let token = LocalStorage().getUserToken() else { return nil }
        let url = "\(BASE_URL)/getPhoto?&token=\(token)"
        return URL(string: url)
    }()
    
    private lazy var yourImageUrl: URL? = {
        guard let token = LocalStorage().getUserToken() else { return nil }
        let url = "\(BASE_URL)/getPhoto?&token=\(token)&userId=\(yourID)"
        return URL(string: url)
    }()

    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackground)))
        
        chat.messages.sort()
        
        messageTextView.delegate = self
        messageTextView.setCoursorToTheBeginningOfTheLine()
        
        if isLoadFromMatchScreen {
            guard let token = localStorage.getUserToken() else { return }
            guard let url = URL(string: "\(SOCKET_URL)/chat?token=\(token)&yourId=\(yourID)") else { return }
            socket = WebSocket(url: url)
            socket.delegate = self
            socket.connect()
        } else {
            textInputView.isHidden = true
        }
        
        titleLabel.text = chat.chatmade.nick
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Private methods
    
    private func setupObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboadNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboadNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate), name: ApplicationWillTerminateNotification, object: nil)
    }
    
    @objc private func handleKeyboadNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomConstraint.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
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
    
    @objc private func applicationWillTerminate() {
        socket?.disconnect()
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        shouldShowDisconnectAlert = false
        socket?.disconnect()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func emojiButtonTapped(_ sender: Any) {
        messageTextView.becomeFirstResponder()
    }
    
    @IBAction private func sendMessageButtonTapped(_ sender: Any) {
        guard let text = messageTextView.text else { return }
        
        socket.write(string: text)
        
        messageTextView.text = ""
        
        let currentDate = String(describing: Int(Date().timeIntervalSince1970))
        // TODO: - ??? id, senderId ???
        let msg = Message(id: "2", chatId: chat.chatId, senderId: "0", text: text, date: currentDate)
        chat.messages.append(msg)
        
        tableView.reloadData()
        let indexPathToScroll = IndexPath(row: chat.messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPathToScroll, at: .bottom, animated: true)
    }
    
    @objc private func didTapBackground() {
        textInputView.resignFirstResponder()
    }
    
    private func showDisconnectAlert() {
        let alertController = UIAlertController(title: "Oh no :(", message: "Your partner has just leaved the chat, try to be a better person next time", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok...", style: .default) { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chat.messages[indexPath.row]
        
        if message.senderId == yourID {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingCell") as? IncomingCell else { return UITableViewCell() }
            cell.configure(message, imageUrl: yourImageUrl)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingCell") as? OutgoingCell else { return UITableViewCell() }
            cell.configure(message, imageUrl: myImageUrl)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - WebSocketDelegate
extension ConversationViewController: WebSocketDelegate {
    
    func websocketDidConnect(socket: WebSocketClient) {
        print(socket)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
        if let error = error {
            showErrorAlert(error.localizedDescription)
        } else if shouldShowDisconnectAlert {
            showDisconnectAlert()
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let data = text.data(using: .utf8) else { return }
        do {
            let message = try JSONDecoder().decode(Message.self, from: data)
            chat.messages.append(message)
            tableView.reloadData()
            let indexPathToScroll = IndexPath(row: chat.messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPathToScroll, at: .bottom, animated: true)
        } catch {
            showErrorAlert(error.localizedDescription)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(data)
    }
}


// MARK: - UITextViewDelegate
extension ConversationViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Type your message..."
            textView.textColor = .lightGray
            
            textView.setCoursorToTheBeginningOfTheLine()
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == .lightGray && !text.isEmpty {
            textView.textColor = .black
            textView.text = text
        }
            
            // For every other case, the text should change with the usual
            // behavior...
        else {
            return true
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if self.view.window != nil {
            if textView.textColor == .lightGray {
                textView.setCoursorToTheBeginningOfTheLine()
            }
        }
    }
}
