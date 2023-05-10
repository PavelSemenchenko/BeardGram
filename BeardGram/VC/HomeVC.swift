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
    
    lazy var authenticationService: AuthenticationService = Locator.authenticationService
    lazy var contactsRepository: ContactsRepository = Locator.contactsRepository
    lazy var navigation: NavigationService = Locator.navigation
    
    var contacts: [Profile] = []
    var allContacts : [Profile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Friends"
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "LogOut",
                                                              style: UIBarButtonItem.Style.plain,
                                                              target: self,
                                                              action: #selector(logOutClicked))]
       
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        contactsTableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), 
                                        forCellReuseIdentifier: "contactCell")
        
        reloadContacts()
    }
    func reloadContacts() {
        contactsRepository.getAll { allContacts in
            self.contacts = allContacts
            self.contactsTableView.reloadData()
        }
    }
    
    @IBAction func searchCloseButtonClicked(_ sender: Any) {
        searchContactsTextField.text = ""
        reloadContacts()
    }
    @IBAction func searchContactFieldButton(_ sender: Any) {
        guard let searchName = searchContactsTextField.text else { return }
        if searchName.isEmpty {
            reloadContacts()
            return
        }
        contactsRepository.search(name: searchName) { result in
            self.contacts = result
            self.contactsTableView.reloadData()
        }
    }
    
    @IBAction func messagesButtonClicked(_ sender: Any) {
        navigation.openRecentMessages(self)
    }
    
    @objc func logOutClicked() {
        authenticationService.logOut()
        if navigationController?.viewControllers.count == 1 {
            guard let viewController = storyboard?.instantiateViewController(withIdentifier: "wellcomeId") else {
                return
            }
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            navigation.backToRoot(self)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        
        cell.data = contacts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigation.openConversation(self, recipient: contacts[indexPath.row].id!)
    }
    
    @IBAction func globalSearchButtonClicked(_ sender: Any) {
        navigation.openGlobalSearch(self)
    }
    
    @IBAction func reloadTableButtonClicked(_ sender: Any) {
        reloadContacts()
    }
    
}
