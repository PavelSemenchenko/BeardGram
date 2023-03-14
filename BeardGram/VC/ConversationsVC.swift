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
    @IBOutlet weak var newMessageTextField: MessageTextField!
    @IBOutlet weak var bgMessagesTableView: UITableView!
    
    let messageRepository: MessagesRepository = FirebaseMessagesRepository()
    var bgMessages: [BGMessage] = []
    var allbgMessages: [BGMessage] = []
    
    var profilesRepository: ProfilesRepository = FirebaseProfilesRepository()
    
    var images: [URL] = []
    
    var recipientId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Conversation"
        
        //recipientNameTextLabel.text = recipientName.data.name
        
        bgMessagesTableView.dataSource = self
        bgMessagesTableView.delegate = self
        bgMessagesTableView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "senderRow")
        reloadMessages()
        
        profilesRepository.getProfile(id: recipientId) { profile in
            self.title = profile?.name
        }
        /*
        registerForKeyboardNotifications()
    }
    deinit {
        removeKeyboardNotifications()
    }
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0.0, y: kbFrameSize.height/1.5)
    }
    @objc func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    */
    }
    
    func reloadMessages() {
        messageRepository.getAll(repicientId: recipientId) { allbgMessages in
            self.bgMessages = allbgMessages
            self.bgMessagesTableView.reloadData()
        }
    }
    
    @IBAction func newMessageSendButtonClicked(_ sender: Any) {
        if let newMessage = newMessageTextField.text, newMessage.count > 1 {
            newMessageTextField.text = ""
            if images.isEmpty {
                messageRepository.sendImages(images: images, recipientId: recipientId, message: newMessage)
            } else {
                messageRepository.sendImages(images: images, recipientId: recipientId, message: newMessage)
                images.removeAll()
            }
            return
        }
        if !images.isEmpty {
            messageRepository.sendImages(images: images, recipientId: recipientId, message: "")
            images.removeAll()
        }
       
    }
    
    @IBAction func attachmentButtonClicked(_ sender: Any) {
        guard let addImage = self.storyboard?.instantiateViewController(withIdentifier: "attachmentsSB") as? AttachmentsVC else {
            return
        }
        // need comletion
        addImage.onImageReady = { imageURL in
            self.images.append(imageURL)
        }
        self.navigationController?.pushViewController(addImage, animated: true)
    }
    
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
