//
//  PasswordTextField.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 23.01.2023.
//

import Foundation
import UIKit

class PasswordTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowOpacity = 1
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.gray.cgColor
    }
    func validatePasswordTextField(errorLabel: UILabel) -> String? {
        let optionalPassword = text
        guard let password = optionalPassword, password.count >= 6 else {
            layer.borderColor = UIColor.red.cgColor
            errorLabel.text = "Password wrong"
            errorLabel.isHidden = false
            return nil
        }
        layer.borderColor = UIColor.green.cgColor
        errorLabel.isHidden = true
        return password
    }
}
