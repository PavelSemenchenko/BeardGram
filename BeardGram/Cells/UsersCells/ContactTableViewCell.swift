//
//  UserTableViewCell.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 31.01.2023.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    let contactsRepository: ContactsRepository = FirebaseContactsRepository()
    @IBOutlet weak var contactNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // contactNameLabel.text = data.name
        // Initialization code
    }
    
    var data: Profile! {
        didSet {
            contactNameLabel.text = data.name
        }
    }
    var  profilesRepository: ProfilesRepository!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var onDeleteCompletion: ((Profile) -> Void)?
    
    @IBAction func deleteFriendButtonClicked(_ sender: Any) {
        deleteFriend()
    }
    func deleteFriend(){
        guard data.id != nil else {
            return
        }
        contactsRepository.delete(profile: data)
    }
    
}
