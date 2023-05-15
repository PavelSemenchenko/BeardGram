//
//  RecentMessagesVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 14.02.2023.
//

import Foundation
import UIKit

class RecentMessagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recentMessagesTableView: UITableView!
    var dialogs: [Dialog] = []
    var allDialogs: [Dialog] = []
    lazy var dialogsRepository: DialogsRepository = Locator.L.dialogsRepository
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recent Messages"
        recentMessagesTableView.dataSource = self
        recentMessagesTableView.delegate = self
        recentMessagesTableView.register(UINib(nibName: "DialogCell", bundle: nil), forCellReuseIdentifier: "dialogRow")
        reloadDialogs()
    }
    func reloadDialogs() {
        dialogsRepository.getAll { allDialogs in
            self.dialogs = allDialogs
            self.recentMessagesTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dialogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dialogRow", for: indexPath) as? DialogCell else {
            fatalError("cell is wrong")
        }
        cell.dialog = dialogs[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversationVc = self.storyboard?.instantiateViewController(withIdentifier: "conversationsSB") as? ConversationsVC else {
            return
        }
        // need add id of the row users
        conversationVc.recipientId = dialogs[indexPath.row].userId
        self.navigationController?.pushViewController(conversationVc, animated: true)
    }
}
