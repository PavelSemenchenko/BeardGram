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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var editingView: UIView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    lazy var messageRepository: MessagesRepository = Locator.messageRepository
    lazy var profilesRepository: ProfilesRepository = Locator.profilesRepository
    
    var bgMessages: [BGMessage] = []
    var allbgMessages: [BGMessage] = []
    
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
        
        profilesRepository.getProfile(id: recipientId) { [weak self ] profile in
            self?.title = profile?.name
            print(profile?.name)
        }
        
        registerForKeyboardNotifications()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            view.addGestureRecognizer(tapGesture)

            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
            swipeGesture.direction = .down
            view.addGestureRecognizer(swipeGesture)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
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
        NotificationCenter.default.removeObserver(self)
    }
    @objc func kbWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            bottomConstraint.constant = keyboardHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func kbWillHide() {
        bottomConstraint.constant = 1
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
    }
    
    func reloadMessages() {
        messageRepository.getAll(recipientId: recipientId) { allbgMessages in
            self.bgMessages = allbgMessages
            self.bgMessagesTableView.reloadData()
        }
    }
    
    @IBAction func newMessageSendButtonClicked(_ sender: Any) {
        if let newMessage = newMessageTextField.text, newMessage.count > 1 {
            newMessageTextField.text = ""
            if images.isEmpty {
                messageRepository.sendText(message: newMessage, recipientId: recipientId)
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
        return cell
    }
}
