//
//  UserTableViewCell.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 31.01.2023.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contactNameLabel.text = data.name
        // Initialization code
    }
    
    var data: Contact! {
        didSet {
            prepareForReuse()
        }
    }
    var  contactRepository: ContactsRepository!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
