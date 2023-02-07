//
//  ProfileAddInfo.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 06.02.2023.
//

import Foundation
import UIKit

class ProfileAddInfo: UIViewController {
    
    @IBOutlet weak var profileAddNameTextField: NameTextField!
    
    let profilesRepository: ProfilesRepository = FirebaseProfilesRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func continueRegButtonClicked(_ sender: Any) {
        onContinue()
    }
    // need button
    func onContinue(){
        guard let name = profileAddNameTextField.text else {
            return
        }
        profilesRepository.createProfile(name: name)
    }
}
