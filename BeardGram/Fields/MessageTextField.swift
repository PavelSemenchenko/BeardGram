//
//  MessageTextField.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 06.02.2023.
//

import Foundation
import UIKit

class MessageTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowOpacity = 1
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.gray.cgColor
    }
}
