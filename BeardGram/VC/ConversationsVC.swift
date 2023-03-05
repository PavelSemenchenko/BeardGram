//
//  ConversationsVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 01.02.2023.
//

import Foundation
import UIKit

class ConversationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recipientNameTextLabel: UILabel!
    @IBOutlet weak var newMessageTextField: MessageTextField!
    @IBOutlet weak var bgMessagesTableView: UITableView!
    
    let messageRepository: MessagesRepository = FirebaseMessagesRepository()
    var bgMessages: [BGMessage] = []
    var allbgMessages: [BGMessage] = []
    
    var profilesRepository: ProfilesRepository = FirebaseProfilesRepository()
    
    var recipientId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Conversation"
        
        bgMessagesTableView.dataSource = self
        bgMessagesTableView.delegate = self
        bgMessagesTableView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "senderRow")
        reloadMessages()
        
        profilesRepository.getProfile(id: recipientId) { profile in
            self.title = profile?.name
        }
        
        registerForKeyboardNotifications()
        
        // keyboard
        cancelKeyboard()
    }
    func cancelKeyboard() {
        self.scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    @objc func hideKeyboard() {
        self.scrollView.endEditing(true)
    }
    // kayboard hide end
    
    deinit {
        removeKeyboardNotifications()
    }
    // add listnener
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // cancel listnener
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // Добавляем отступ снизу к scrollView, чтобы он прокручивался до уровня текстового поля
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height/2, right: 0)
            
            // Перемещаем scrollView, чтобы текстовое поле было видимым
            if let activeTextField = newMessageTextField {
                let textFieldRect = activeTextField.convert(activeTextField.bounds, to: scrollView)
                scrollView.scrollRectToVisible(textFieldRect, animated: true)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Удаляем отступ снизу у scrollView
        scrollView.contentInset = .zero
    }
    private func textFieldDidBeginEditing(_ textField: MessageTextField) {
        newMessageTextField = textField
    }

    private func textFieldDidEndEditing(_ textField: MessageTextField) {
        newMessageTextField = nil
    }

    // old scheme
    /*
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0.0, y: kbFrameSize.height/1.2)
    }*/
   
    
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
