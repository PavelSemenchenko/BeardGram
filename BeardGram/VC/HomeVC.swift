//
//  HomeVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 23.01.2023.
//

import Foundation
import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var searchContactsTextField: UITextField!
    @IBOutlet weak var contactsTableView: UITableView!
    
    let authenticationService: AuthenticationService = FirebaseAuthenticationService()
    let contactRepository = ContactsRepository()
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts list"
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "LogOut",
                                                              style: UIBarButtonItem.Style.plain,
                                                              target: self,
                                                              action: #selector(logOutClicked))]
        
        let cellNib = UINib(nibName: "ContactTableViewCell", bundle: nil)
    }
    
    @IBAction func addContactButtonClicked(_ sender: Any) {
    }
    
    
    @objc func logOutClicked() {
        authenticationService.logOut()
        if navigationController?.viewControllers.count == 1 {
            guard let viewController = storyboard?.instantiateViewController(withIdentifier: "signInSB") else {
                return
            }
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
}
