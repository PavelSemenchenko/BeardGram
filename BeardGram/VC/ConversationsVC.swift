//
//  ConversationsVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 01.02.2023.
//

import Foundation
import UIKit

class ConversationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recipientNameTextLabel: UILabel!
    @IBOutlet weak var searchMessageTextField: UITextField!
    @IBOutlet weak var newMessageTextField: MessageTextField!
    @IBOutlet weak var bgMessagesTableView: UITableView!
    
    let messageRepository: MessagesRepository = FirebaseMessagesRepository()
    var bgMessages: [BGMessage] = []
    var allbgMessages: [BGMessage] = []
    
    var recipientId: String = "sK9DgapXvObXVAXVZSFgq07w9Kt2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Conversation"
        bgMessagesTableView.dataSource = self
        bgMessagesTableView.delegate = self
        bgMessagesTableView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "senderRow")
        reloadMessages()
    }
    func reloadMessages() {
        messageRepository.getAll(repicientId: recipientId) { allbgMessages in
            self.bgMessages = allbgMessages
            self.bgMessagesTableView.reloadData()
        }
    }
    
    @IBAction func newMessageSendButtonClicked(_ sender: Any) {
        guard let newMessage = newMessageTextField.text, newMessage.count > 1 else {
            return
        }
        messageRepository.sendText(message: newMessage, recipientId: recipientId)
    }
    
    @IBAction func attachmentButtonClicked(_ sender: Any) {
    }
    
    /*
    @IBAction func searchMessageTextField(_ sender: Any) {
        guard let searchText = searchMessageTextField.text?.lowercased() else { return }
        if searchText.isEmpty {
            dialogs = allDialogs
            recentMessagesTableView.reloadData()
            return
        }
        var searchMessages: [Dialog] = []
        for dialog in allDialogs {
            if dialog.lastMessage.lowercased().contains(searchText) {
                searchMessages.append(dialog)
            }
            dialogs = searchMessages
            recentMessagesTableView.reloadData()
        }
    }
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bgMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "senderRow", for: indexPath) as? SenderCell else {
            fatalError("cell is wrong")
        }
        cell.bgMessage = bgMessages[indexPath.row]
        
        /*cell.onDeleteCompletion = { dialogToDelete in
            //self.dialogsRepository.delete(dialogId: dialogToDelete.id!)
            //self.dialogs.remove(at: indexPath.row)
            self.recentMessagesTableView.reloadData()
        }*/
        return cell
    }
}
