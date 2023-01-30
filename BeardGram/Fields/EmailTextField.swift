//
//  EmailTextField.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 23.01.2023.
//

import Foundation
import UIKit

class EmailTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
        layer.shadowOpacity = 1
        layer.shadowRadius = 12.0
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.gray.cgColor
         */
    }
    func validateEmailTextField(errorLabel: UILabel) -> String? {
        let optionalEmail = text
        guard let email = optionalEmail, email.contains("@") else {
            layer.borderColor = UIColor.red.cgColor
            errorLabel.text = "Email is invalid"
            errorLabel.isHidden = false
            return nil
        }
        layer.borderColor = UIColor.green.cgColor
        errorLabel.isHidden = true
        return email
    }
}
