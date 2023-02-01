//
//  HomeVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 23.01.2023.
//

import Foundation
import UIKit

class HomeVC: UIViewController, UITableViewDataSource {
    
    
    
    @IBOutlet weak var searchContactsTextField: UITextField!
    @IBOutlet weak var contactsTableView: UITableView!
    
    let authenticationService: AuthenticationService = FirebaseAuthenticationService()
    // let contactRepository = ContactsRepository()
    var allContacts: [Contact] = [Contact(id: 0, name: "Tom", email: "1@2.com"),
                                  Contact(id: 1, name: "John", email: "2@3.com"),
                                  Contact(id: 2, name: "Sarah", email: "3@4.com"),]
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts list"
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "LogOut",
                                                              style: UIBarButtonItem.Style.plain,
                                                              target: self,
                                                              action: #selector(logOutClicked))]
        //  отображаем массив через ячейку
        contactsTableView.dataSource = self
        contactsTableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "contactCell")
        contactsTableView.reloadData()
        contacts = allContacts
        
    }
    
    @IBAction func searchContactFieldButton(_ sender: Any) {
        guard let searchName = searchContactsTextField.text?.lowercased() else { return }
        if searchName.isEmpty {
            contacts = allContacts
            contactsTableView.reloadData()
            return
        }
        var searchContacts: [Contact] = []
        for contact in allContacts {
            if contact.name.lowercased().contains(searchName) {
                searchContacts.append(contact)
            }
        }
        contacts = searchContacts
        contactsTableView.reloadData()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        guard let contactCell = cell as? ContactTableViewCell else {
            fatalError("Error")
        }
        let contact = contacts[indexPath.row]
        contactCell.contactNameLabel.text = contact.name
        return contactCell
    }
    
}
