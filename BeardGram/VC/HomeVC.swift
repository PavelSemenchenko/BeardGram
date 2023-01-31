//
//  HomeVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 23.01.2023.
//

import Foundation
import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    let contactRepository = ContactsRepository()
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    title = "Contacts list"
        
        let cellNib = UINib(nibName: "ContactTableViewCell", bundle: nil)
    }
    
    
    
}
