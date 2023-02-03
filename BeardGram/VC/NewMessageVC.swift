//
//  NewMessageVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 01.02.2023.
//

import Foundation
import UIKit

/*
enum NewDialogMode {
    case create
    case edit
}*/

class NewMessageVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var newMessageView: UIView!
    @IBOutlet weak var newMessageTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    let dialogsRepository: DialogsRepository  = FirebaseDialogsRepository()
    var onCreateCompletion: ((Dialog?) -> Void)?
    
    //var onUpdateCompletion: ((Dialog?) -> Void)
    // var mode: NewDialogMode = NewDialogMode.create
    // var editDialog: Dialog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        if mode == NewDialogMode.create {
            title = "Create new message"
        } else {
            title = "Editing ..."
        }
        
        newMessageTextField.text = editDialog?.title
         */
    }
    
    
    @IBAction func sendNewMessageButtonCLicked(_ sender: Any) {
        guard let title = newMessageTextField.text, title.count > 3 else {
            errorMessageLabel.text = "Text can`t be empty"
            return
        }
        let newMessage = dialogsRepository.create(title: title)
        self.onCreateCompletion?(newMessage)
        
        self.navigationController?.popViewController(animated: true)
    }
    /*
    @objc func onCreateClicked() {
        guard let title = newMessageTextField.text, title.count > 3 else {
            return
        }
        let newDialog = dialogsRepository.create(title: title)
        self.onCreateCompletion(newDialog)
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onUpdateClicked() {
        guard let oldDialog = editDialog,
              let title = newMessageTextField.text, title.count > 3 else {
            return
        }
        let updateDialog = Dialog(id:oldDialog.id, title: title, created: oldDialog.created, authorId: oldDialog.authorId)
        dialogsRepository.update(value: updateDialog)
        self.onUpdateCompletion(updateDialog)
        self.navigationController?.popViewController(animated: true)
    }*/
}
