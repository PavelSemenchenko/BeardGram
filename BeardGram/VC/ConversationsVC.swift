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
    
    @IBOutlet weak var recentMessagesTableView: UITableView!
    
    let dialogsRepository: DialogsRepository = FirebaseDialogsRepository()
    let messageRepository: MessageRepository = FirebaseMessageRepository()
    var dialogs: [Dialog] = []
    var allDialogs: [Dialog] = []
    // let authenticationService: AuthenticationService = FirebaseAuthenticationService()
    
    var recipientId: String = "fMPzRnaqKQRN43cSuP1cDbtCkln2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Conversation"
        /*
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "New message",
                                                              style: UIBarButtonItem.Style.plain,
                                                              target: self,
                                                              action: #selector(newMessage))]
         */
        recentMessagesTableView.dataSource = self
        recentMessagesTableView.delegate = self
        recentMessagesTableView.register(UINib(nibName: "DialogCell", bundle: nil), forCellReuseIdentifier: "dialogRow")
        reloadDialogs()
    }
    
    @objc func newMessage() {
        
            guard let viewController = storyboard?.instantiateViewController(withIdentifier: "newMessageSB") else {
                return
            }
            navigationController?.pushViewController(viewController, animated: true)
        
    }
    func reloadDialogs() {
        dialogsRepository.getAll { allDialogs in
            self.dialogs = allDialogs
            self.recentMessagesTableView.reloadData()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dialogRow", for: indexPath) as? DialogCell else {
            fatalError("cell is wrong")
        }
        cell.dialog = dialogs[indexPath.row]
        cell.onDeleteCompletion = { dialogToDelete in
            //self.dialogsRepository.delete(dialogId: dialogToDelete.id!)
            //self.dialogs.remove(at: indexPath.row)
            self.recentMessagesTableView.reloadData()
        }
        return cell
    }
}
