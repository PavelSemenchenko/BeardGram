//
//  ProfileTableViewCell.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 07.02.2023.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileNameLabel: UILabel!
    //var contacts: [Profile] = []
    //var allContacts : [Profile] = []
    let contactsRepository: ContactsRepository = FirebaseContactsRepository()
    var onAddFriendCompletion: ((Profile?) -> Void)?
    //var profilesRepository: ProfilesRepository!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var data: Profile! {
        didSet {
            profileNameLabel.text = data.name
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func appendProfileToFriendsButtonClicked(_ sender: Any) {
        addFriend()
        
    }
    
    func addFriend() {
        guard let name = profileNameLabel.text else {
            return
        }
        guard let id = data.id else {
            return
        }
        let addFiend = contactsRepository.append(profile: Profile.init(id: id, name: name))
        self.onAddFriendCompletion?(addFiend)
        
    }
}
