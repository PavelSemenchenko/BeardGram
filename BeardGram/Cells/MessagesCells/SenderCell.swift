//
//  SenderTableViewCell.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 14.02.2023.
//

import UIKit

class SenderCell: UITableViewCell {

    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var attachmentsStackView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var bgMessage: BGMessage! {
        didSet {
            messageTextLabel.text = bgMessage.text
            // timeLabel.text = bgMessage.created
        }
    }
    
}
