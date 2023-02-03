//
//  ConversationsVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 01.02.2023.
//

import Foundation
import UIKit

class ConversationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchMessageTextField: UITextField!
    @IBOutlet weak var recentMessagesTableView: UITableView!
    
    //var userId: String!
    
    let dialogsRepository: DialogsRepository = FirebaseDialogsRepository()
    var dialogs: [Dialog] = []
    var allDialogs: [Dialog] = []
    let authenticationService: AuthenticationService = FirebaseAuthenticationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Messages"
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "New message",
                                                              style: UIBarButtonItem.Style.plain,
                                                              target: self,
                                                              action: #selector(newMessage))]
        recentMessagesTableView.dataSource = self
        recentMessagesTableView.delegate = self
        recentMessagesTableView.register(UINib(nibName: "DialogCell", bundle: nil), forCellReuseIdentifier: "dialogRow")
        reloadDialogs()
    }
    func reloadDialogs() {
        dialogsRepository.getAll { dialogs in
            self.dialogs = dialogs
            self.recentMessagesTableView.reloadData()
        }
    }
    @objc func newMessage() {
        
            guard let viewController = storyboard?.instantiateViewController(withIdentifier: "newMessageSB") else {
                return
            }
            navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dialogRow", for: indexPath) as? DialogCell else {
            fatalError("cell is wrong")
        }
        cell.dialog = dialogs[indexPath.row]
        cell.onDeleteCompletion = { dialogToDelete in
            self.dialogsRepository.delete(dialogId: dialogToDelete.id!)
            self.dialogs.remove(at: indexPath.row)
            self.recentMessagesTableView.reloadData()
        }
        return cell
    }
}
