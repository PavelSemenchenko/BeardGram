//
//  HomeVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 23.01.2023.
//

import Foundation
import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
        
    @IBOutlet weak var searchContactsTextField: UITextField!
    @IBOutlet weak var contactsTableView: UITableView!
        
    let authenticationService: AuthenticationService = FirebaseAuthenticationService()
    
    let contactsRepository: ContactsRepository = FirebaseContactsRepository()
    var contacts: [Contact] = []
    var allContacts : [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts list"
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "LogOut",
                                                              style: UIBarButtonItem.Style.plain,
                                                              target: self,
                                                              action: #selector(logOutClicked))]
       
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        contactsTableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "contactCell")
        
        reloadContacts()
    }
    func reloadContacts() {
        contactsRepository.getAll { allContacts in
            self.contacts = allContacts
            self.contactsTableView.reloadData()
        }
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
        let sbAddContact = UIStoryboard(name: "AddContactSB", bundle: nil)
        let ctrAddContact = sbAddContact.instantiateViewController(withIdentifier: "addContact") as! AddContactVC
        ctrAddContact.onCreateCompletion = { newContact in
            if let contact = newContact {
                self.allContacts.append(contact)
                self.contactsTableView.reloadData()
            }
        }
        self.navigationController?.pushViewController(ctrAddContact, animated: true)
    }
    
    @IBAction func messagesButtonClicked(_ sender: Any) {
        guard let mess = self.storyboard?.instantiateViewController(withIdentifier: "conversationsSB")
                as? ConversationsVC else { return
        }
        self.navigationController?.pushViewController(mess, animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        
        cell.data = contacts[indexPath.row]
        cell.contactRepository = contactsRepository
        //let contact = allContacts[indexPath.row]
       // contactCell.contactNameLabel.text = contact.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let sBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let conversationVc = self.storyboard?.instantiateViewController(withIdentifier: "conversationsSB") as? ConversationsVC else {
            return
        }
        //conversationVc.userId = contacts[indexPath.row].id
        self.navigationController?.pushViewController(conversationVc, animated: true)
    }
    
    @IBAction func globalSearchButtonClicked(_ sender: Any) {
        guard let globalSearch = self.storyboard?.instantiateViewController(withIdentifier: "globalSearchSB") as? GlobalSearchVC else {
            return
        }
        self.navigationController?.pushViewController(globalSearch, animated: true)
    }
    
}
