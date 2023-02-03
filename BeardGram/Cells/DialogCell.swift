//
//  DialogCell.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 03.02.2023.
//

import UIKit

class DialogCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var dialog: Dialog! {
        didSet {
            titleLabel.text = dialog.title
        }
    }
    var onDeleteCompletion: ((Dialog) -> Void)?
    
    @IBAction func deleteClecked(_ sender: Any) {
        onDeleteCompletion?(dialog)
    }
}
