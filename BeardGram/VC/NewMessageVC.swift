//
//  NewMessageVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 01.02.2023.
//

import Foundation
import UIKit

class NewMessageVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var newMessageView: UIView!
    @IBOutlet weak var newMessageTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    let dialogsRepository: MessageRepository  = FirebaseMessageRepository()
    var recipientId: String = "sK9DgapXvObXVAXVZSFgq07w9Kt2"

    //var onCreateCompletion: ((Dialog?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newMessageView.layer.shadowOpacity = 1
        newMessageView.layer.shadowRadius = 12.0
        newMessageView.layer.shadowOffset = CGSize.zero
        newMessageView.layer.shadowColor = UIColor.gray.cgColor
        
    }
   
    @IBAction func sendNewMessageButtonCLicked(_ sender: Any) {
        guard let title = newMessageTextField.text, title.count > 3 else {
            errorMessageLabel.text = "Text can`t be empty"
            return
        }
        dialogsRepository.sendText(message: title, recipientId: recipientId)
        //let newMessage = dialogsRepository.create(title: title)
        //self.onCreateCompletion?(newMessage)
        
        self.navigationController?.popViewController(animated: true)
    }
}
