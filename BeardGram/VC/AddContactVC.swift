//
//  AddContactVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 03.02.2023.
//

import Foundation
import UIKit

class AddContactVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var addEmailTextField: UITextField!
    
    @IBOutlet weak var errorNameLabel: UILabel!
    @IBOutlet weak var errorEmailLabel: UILabel!
    
    let contactRepository: ContactsRepository = FirebaseContactsRepository()
    var onCreateCompletion: ((Profile?) -> Void)?
    
    @IBAction func addContactButtonClicked(_ sender: Any) {
        guard let name = addNameTextField.text, name.count > 2 else {
            errorNameLabel.text = "Name must be longer"
            return
        }
        let optionalEmail = addEmailTextField.text
        guard let email = optionalEmail, email.contains("@") else {
            errorEmailLabel.text = "Enter correct email"
            return
        }
        let updContact = contactRepository.append(profile: Profile(name: name))
        
        self.navigationController?.popViewController(animated: true)
    }
}
