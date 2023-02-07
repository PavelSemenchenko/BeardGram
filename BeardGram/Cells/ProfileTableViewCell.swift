//
//  ProfileTableViewCell.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 07.02.2023.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileNameLabel: UILabel!
    
    //let contactRepository: ContactsRepository = FirebaseContactsRepository()
    var profilesRepository: ProfilesRepository!
    
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
        guard let name = profileNameLabel.text else {
            return
        }
        //let updProfile = contactRepository.append(profile: Profile(name: name))
        // and go home screen
    }
}
