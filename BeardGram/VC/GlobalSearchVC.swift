//
//  GlobalSearchVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 06.02.2023.
//

import Foundation
import UIKit

class GlobalSearchVC: UIViewController {
    
    @IBOutlet weak var globalSearchTextField: UITextField!
    
    @IBOutlet weak var globalSearchTableView: UITableView!
    var onAddFriendCompletion: ((Profile?) -> Void)?
    var profilesRepository: ProfilesRepository!
    
    var profiles: [Profile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Global users list"
        globalSearchTableView.dataSource = self
        globalSearchTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "profileCell")
    }
    
    @IBAction func globalSearchButtonClicked(_ sender: Any) {
        guard let term = globalSearchTextField.text else {
            return
        }
         profilesRepository.search(name: term) {result in
            self.profiles = result
            self.globalSearchTableView.reloadData()
        }
    }
    
}

extension GlobalSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        cell.data = profiles[indexPath.row]
        return cell
    }
}
