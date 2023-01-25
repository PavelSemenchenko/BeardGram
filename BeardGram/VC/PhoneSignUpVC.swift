//
//  PhoneSignUpVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 25.01.2023.
//

import Foundation
import UIKit
import FirebaseAuth
import FlagPhoneNumber

class PhoneSignUpVC: UIViewController {
    var phoneNumber: String?
    var listController : FPNCountryListViewController!
    
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var getCodeButton: UIButton!
    
    
    @IBOutlet weak var checkCodeTextField: UITextField!
    @IBOutlet weak var checkCodeButton: UIButton!
    
    
    @IBAction func getCodeButtonClicked(_ sender: Any) {
        guard phoneNumber != nil else { return }
        
        PhoneAuthPovider
        
    }
    
    @IBAction func checkCodeButtonClicked(_ sender: Any) {
    }
}
