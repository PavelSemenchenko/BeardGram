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
    
    let dialogsRepository: DialogsRepository  = FirebaseDialogsRepository()
    var onCreateCompletion: ((Dialog?) -> Void)?
   
    @IBAction func sendNewMessageButtonCLicked(_ sender: Any) {
        guard let title = newMessageTextField.text, title.count > 3 else {
            errorMessageLabel.text = "Text can`t be empty"
            return
        }
        let newMessage = dialogsRepository.create(title: title)
        self.onCreateCompletion?(newMessage)
        
        self.navigationController?.popViewController(animated: true)
    }
}
